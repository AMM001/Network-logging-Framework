//
//  NetworkClient.swift
//  InstabugNetworkClient
//
//  Created by Yousef Hamza on 1/13/21.
//

import Foundation

//public class NetworkClient {
//    public static var shared = NetworkClient()
//    
//    // MARK: Network requests
//    public func get(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
//        executeRequest(url, method: "GET", payload: nil, completionHandler: completionHandler)
//    }
//    
//    public func post(_ url: URL, payload: Data?=nil, completionHandler: @escaping (Data?) -> Void) {
//        executeRequest(url, method: "POSt", payload: payload, completionHandler: completionHandler)
//    }
//    
//    public func put(_ url: URL, payload: Data?=nil, completionHandler: @escaping (Data?) -> Void) {
//        executeRequest(url, method: "PUT", payload: payload, completionHandler: completionHandler)
//    }
//    
//    public func delete(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
//        executeRequest(url, method: "DELETE", payload: nil, completionHandler: completionHandler)
//    }
//    
//    func executeRequest(_ url: URL, method: String, payload: Data?, completionHandler: @escaping (Data?) -> Void) {
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = method
//        urlRequest.httpBody = payload
//        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//#warning("Record request/response")
//            // fatalError("Not implemented")
//            
//            DispatchQueue.main.async {
//                completionHandler(data)
//            }
//        }.resume()
//    }
//    
//    // MARK: Network recording
//#warning("Replace Any with an appropriate type")
//    public func allNetworkRequests() -> Any {
//        fatalError("Not implemented")
//    }
//}

open class NetworkClient: NSObject, ResponseValidation {
    
    static public let instance = NetworkClient()
    
    var sessionManager: SessionManager?
    
    let dispatchQueue = DispatchQueue.global()
    
    private init(sessionManager: SessionManager = SessionManager()) {
        super.init()
        self.sessionManager = sessionManager
    }
    
    internal func dataTask(with request: URLRequestConvertible, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        guard let urlRequest = try? request.asURLRequest() else {
            completionHandler(nil, nil, APIError.invalidRequest)
            return nil
        }
        
        let dataTask = sessionManager?.session?.dataTask(with: urlRequest) { (data, response, error) in
            completionHandler(data, response, error)
        }
        return dataTask
    }
    
    open func request(with request: URLRequestConvertible, completion: @escaping (OperationResult) -> Void) {
        let task = self.dataTask(with: request, completionHandler: { [weak self] (data, urlResponse, error) in
            guard let self = self else {return}
            self.handelServerResponse(data: data, urlResponse: urlResponse, error: error) { operationResult in
                DispatchQueue.main.async {
                    completion(operationResult)
                }
                self.saveRequestData(request: request, operationResult: operationResult)
            }
        })
        task?.resume()
    }
    
    func validateRequest() {
        let context = PersistentContainer.shared.viewContext
        dispatchQueue.sync() {
            print("recordsLimitValidation start")
            RequestOperationsHandler.shared.recordsLimitValidation(in: context)
            print("recordsLimitValidation finished")
        }
    }
    
    func saveRequestData(request: URLRequestConvertible, operationResult: OperationResult) {
        let context = PersistentContainer.shared.viewContext
        let requestConvertable = RequestConvertible(for: request)
        dispatchQueue.async() { [weak self] in
            defer {
                self?.validateRequest()
            }
            print("save request start")
            RequestOperationsHandler.shared.save(context: context, values: requestConvertable, operationResult: operationResult)
            print("save request finished")
        }
    }
    
    func handelServerResponse(data: Data?, urlResponse: URLResponse?, error: Error?,  completion: @escaping (OperationResult) -> Void) {
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            completion(OperationResult.error(APIError.invalidResponse, nil))
            return
        }
        let result = self.verify(data: data, urlResponse: urlResponse, error: error)
        switch result {
        case .success(let data):
            completion(OperationResult.result(data, urlResponse))
        case .failure(let error):
            completion(OperationResult.error(APIError.unknown(error.localizedDescription), urlResponse))
        }
    }
    
    deinit {
        sessionManager?.session?.finishTasksAndInvalidate()
    }
}

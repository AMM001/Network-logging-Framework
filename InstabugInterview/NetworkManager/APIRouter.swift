//
//  APIRouter.swift
//  InstabugInterview
//
//  Created by admin on 07/04/2022.
//

import Foundation
import InstabugNetworkClient
import CoreLocation

enum APIRouter: URLRequestConvertible {
    
    case getRequest
    case postRequest
    case PutRequest
    case deleteRequest
    
    var baseURL: String {
        "https://httpbin.org/"
    }
    
    var endPoint: String {
        switch self {
        case .getRequest:
            return "get"
        case .postRequest:
            return "post"
        case .PutRequest:
            return "put"
        case .deleteRequest:
            return "delete"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postRequest:
            return .post
        case .getRequest:
            return .get
        case .PutRequest:
            return .put
        case .deleteRequest:
            return .delete
        }
    }
    
    var headers: HTTPHeaders? { ["Content-Type": "text/plain"] }
    
    var parameters: Parameters? {
        switch self {
        case .getRequest,.postRequest, .PutRequest , .deleteRequest:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL + endPoint)!
        
        switch self {
        case .getRequest,.postRequest, .PutRequest , .deleteRequest:
            return makeURLRequest(url)
        }
    }
    
    func makeURLRequest(_ url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}

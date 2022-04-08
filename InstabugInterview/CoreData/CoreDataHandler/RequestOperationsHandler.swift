//
//  RequestOperationsHandler.swift
//  InstabugInterview
//
//  Created by admin on 07/04/2022.
//

import Foundation
import CoreData

open class RequestOperationsHandler {
    
    public static let shared = RequestOperationsHandler()
    
    private init() {
        
    }
    
    //MARK:- Save CoreData
    func save(context: NSManagedObjectContext, values: RequestConvertible, operationResult: OperationResult) {
        context.perform { [weak self] in
            let responseEntity = Response(context: context)
            let requestEntity = Request(context: context)
            switch operationResult {
            case .result(let data, let response):
                let responseSuccess = Success(context: context)
                responseSuccess.payloadBody = data?.validate()
                responseSuccess.statusCode = Int64(response?.statusCode ?? 0)
                responseEntity.success = responseSuccess
            case .error(let error, let response):
                let responseError = Failure(context: context)
                responseError.errorDomain = error?.localizedDescription
                responseError.errorCode = Int64(response?.statusCode ?? 0)
                responseEntity.failure = responseError
            }
            requestEntity.httpMethod = values.method.rawValue
            requestEntity.payload = values.$parameters
            requestEntity.requestURL = values.baseURL + values.endPoint
            self?.save(context: context)
        }
    }
    
    
    //MARK:- fetchRequests && fetchResponses
    func recordsLimitValidation(in context: NSManagedObjectContext) {
        context.perform { [weak self] in
            let fetchRequests = Request.fetchRequest()
            let fetchResponses = Response.fetchRequest()
            self?.limitValidation(context: context,
                                  fetchRequests: fetchRequests, fetchResponses)
            
        }
    }
    
    //MARK:- Limitation Records
    //The framework should store up to 1,000 records. A record contains a request/response pair.
    func limitValidation(context: NSManagedObjectContext, fetchRequests: NSFetchRequest<NSFetchRequestResult>...) {
        do {
            for fetchRequest in fetchRequests {
                fetchRequest.shouldRefreshRefetchedObjects = true
                let records = try context.fetch(fetchRequest)
                if  records.count > 1000 {
                    guard let record = records.first as? NSManagedObject else {
                        throw CoreDataError.entityTypeError
                    }
                    context.delete(record)
                    save(context: context)
                }
            }
            print("requests count \(try context.fetch(fetchRequests[0]).count), Responses count \(try context.fetch(fetchRequests[0]).count))")
        } catch {
            print("Failed to delete record: \(error)")
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            context.reset()
        } catch {
            print("Error: Failed to insert save request: \(error)")
        }
    }
    
    //MARK:- Get Data Records
    public func getDataRecords(context: NSManagedObjectContext) -> [String] {
        var requestType = [String]()
        do {
            let results   = try context.fetch(Request.fetchRequest())
            if  let dataRecords = results as? [Request] {
                for record in dataRecords {
                    print("getDataRecords.........\(record.httpMethod ?? "")")
                    requestType.append(record.httpMethod ?? "")
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return requestType
    }
    
    public func deleteAllRecords() {
        DispatchQueue.global().async {
            let storeContainer = PersistentContainer.shared.persistentStoreCoordinator
            do {
                // Delete each existing persistent store
                for store in storeContainer.persistentStores {
                    try storeContainer.destroyPersistentStore( at: store.url!, ofType: store.type, options: nil)
                }
            }catch {
                print("Failed to delete records: \(error)")
            }
            PersistentContainer.shared.loadPersistentStores()
        }
    }
}

//
//  Response.swift
//  InstabugInterview
//
//  Created by admin on 07/04/2022.
//

import Foundation
import CoreData

final class Response: NSManagedObject, Identifiable {
    @NSManaged public var success: Success?
    @NSManaged public var failure: Failure?
}

final class Success: NSManagedObject, Identifiable {
    @NSManaged var payloadBody: Data?
    @NSManaged var statusCode: Int64
}

final class Failure: NSManagedObject, Identifiable {
    @NSManaged public var errorCode: Int64
    @NSManaged public var errorDomain: String?
}

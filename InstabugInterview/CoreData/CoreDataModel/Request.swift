//
//  Request.swift
//  InstabugInterview
//
//  Created by admin on 07/04/2022.
//

import Foundation
import CoreData

final class Request: NSManagedObject, Identifiable {
    @NSManaged public var httpMethod: String?
    @NSManaged public var payload: Data?
    @NSManaged public var requestURL: String?
}

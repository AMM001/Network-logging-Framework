//
//  PersistentContainer.swift
//  InstabugInterview
//
//  Created by admin on 07/04/2022.
//

import Foundation
import CoreData

open class PersistentContainer: NSPersistentContainer {
    
    public static let shared = PersistentContainer(name: "NetworkClientCoreData")
    
    open override func newBackgroundContext() -> NSManagedObjectContext {
        let context = super.newBackgroundContext()
        context.name = "background_context"
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    public func loadPersistentStores() {
        loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                 fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
    
}

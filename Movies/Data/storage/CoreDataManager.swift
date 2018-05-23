//
//  CoreDataManager.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataError: MoviesErrorProtocol {
    case tooManyValues
    case fetchError(error: Error)
    case saveError(error: Error)
}

/**
 * CoreDataManager is responsible for manages all CoreData Stack and provides an interface to access it. Basically it's a wrapper to CoreDataPersistenceUnit.
 */
class CoreDataManager {
    
    // *************************************************
    // MARK: - Singleton | Init
    // *************************************************
    
    static var shared = CoreDataManager()
    
    private init() {

    }
    
    // *************************************************
    // MARK: - Properties
    // *************************************************
    
    private lazy var _container: NSPersistentContainer = {
        // debug
        print("[database Path] -> \(NSPersistentContainer.defaultDirectoryURL())")
        
        let container = NSPersistentContainer(name: AppDelegate.shared.appName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var mainContext: NSManagedObjectContext = {
        return _container.viewContext
    }()
    
    func newBackgroundContext() -> NSManagedObjectContext {
        let backgroundContext = _container.newBackgroundContext()
        backgroundContext.parent = mainContext
        return backgroundContext
    }

    // *************************************************
    // MARK: - Operations
    // *************************************************
    
    func saveContext() throws {

        guard mainContext.hasChanges else { return }
        do {
            try mainContext.save()
        } catch  let error as NSError {
            throw CoreDataError.saveError(error: error)
        }
    }
}

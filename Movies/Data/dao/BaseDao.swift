//
//  BaseDao
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    static var name: String { return String(describing: self) }
}

protocol BaseDao {
    associatedtype Entity where Entity: NSManagedObject
}

extension BaseDao {

    static func newInstance() -> Entity {
        return NSEntityDescription.insertNewObject(forEntityName: Entity.name, into: CoreDataManager.shared.mainContext) as! Entity
    }

    static func delete(entity: Entity) {
        CoreDataManager.shared.mainContext.delete(entity)
    }

    /// Remove all records of Entity from DataBase
    static func clear() throws {
        
        let entities = try Self.list()
        entities.forEach({ (entity) in
            Self.delete(entity: entity)
        })
    }
    
    static func count(predicate: NSPredicate? = nil) -> Int {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.name)
        fetchRequest.predicate = predicate
        let count = try? CoreDataManager.shared.mainContext.count(for: fetchRequest)
        
        return count ?? 0
    }
    
    static func find(_ predicate: NSPredicate) throws -> Entity? {
        
        let list = try self.list(predicate)
        if list.count > 1 {
            throw CoreDataError.tooManyValues
        } else {
            return list.first
        }
    }
    
    static func find(byId id: AnyObject?) throws -> Entity? {
        
        guard let id = id as? NSNumber else { return nil }
        return try self.find(NSPredicate(format: "id = %@", id))
    }

    static func list(_ predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil) throws -> [Entity] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.name)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        if let limit = limit, limit > 0 {
            fetchRequest.fetchLimit = limit
        }
        
        var result: [Entity] = []
        do {
            let list = try CoreDataManager.shared.mainContext.fetch(fetchRequest)
            result = list.map({ $0 as! Entity })
        }
        catch let error as NSError {
            throw CoreDataError.fetchError(error: error)
        }
        
        return result
    }
}

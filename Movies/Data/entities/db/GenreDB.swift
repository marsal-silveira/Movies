//
//  GenreDB.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import CoreData

@objc(GenreDB)
final class GenreDB: NSManagedObject {
    
    @NSManaged var id: NSNumber
    @NSManaged var name: String
}

extension GenreDB {
    
    @discardableResult
    static func fromEntity(_ entity: Genre) -> GenreDB {
        
        let genre = GenreDao.newInstance()
        genre.id = NSNumber(value: entity.id)
        genre.name = entity.name
        
        return genre
    }
    
    func toEntity() -> Genre {
        return Genre(id: self.id.intValue, name: self.name)
    }
}

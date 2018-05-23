//
//  GenreDao.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

protocol GenreDaoProtocol {
    func getAll() throws -> [Genre]
    func save(genres: [Genre]) throws
    func clear() throws
}

class GenreDao: BaseDao {
    typealias Entity = GenreDB
}

extension GenreDao: GenreDaoProtocol {

    func getAll() throws -> [Genre] {
        let list = try GenreDao.list()
        return list.map({ (genreDB) -> Genre in genreDB.toEntity() })
    }

    func save(genres: [Genre]) throws {

        for genre in genres {
            GenreDB.fromEntity(genre)
        }
        try CoreDataManager.shared.saveContext()
    }
    
    func clear() throws {
        try GenreDao.clear()
    }
}

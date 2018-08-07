//
//  MovieDao.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

protocol MovieDaoProtocol {
    func getAll() throws -> [Movie]
    func save(movies: [Movie]) throws
    func clear() throws
}

class MovieDao: BaseDao {
    typealias Entity = MovieDB
}

extension MovieDao: MovieDaoProtocol {
    
    func getAll() throws -> [Movie] {
        
        let list = try MovieDao.list()
        return list.map({ (movieDB) -> Movie in movieDB.toEntity() })
    }
    
    func save(movies: [Movie]) throws {
        
        for movie in movies {
            MovieDB.fromEntity(movie)
        }
        try CoreDataManager.shared.saveContext()
    }
    
    func clear() throws {
        try MovieDao.clear()
    }
}

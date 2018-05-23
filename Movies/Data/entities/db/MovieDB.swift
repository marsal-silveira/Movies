//
//  MovieDB.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import CoreData

@objc(MovieDB)
final class MovieDB: NSManagedObject {
    
    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var posterPath: String?
    @NSManaged var backdropPath: String?
    @NSManaged var releaseDate: String
    @NSManaged var overview: String
    @NSManaged var rating: NSNumber
    @NSManaged var genres: Set<GenreDB>
}

extension MovieDB {

    func appendGenre(_ genre: GenreDB) {
        let genres = self.mutableSetValue(forKey: "genres")
        genres.add(genre)
    }
    
    func removeAllGenres() {
        let genres = self.mutableSetValue(forKey: "genres")
        genres.removeAllObjects()
    }
}

extension MovieDB {
    
    @discardableResult
    static func fromEntity(_ entity: Movie) -> MovieDB {
        
        let movie = MovieDao.newInstance()
        movie.id = NSNumber(value: entity.id)
        movie.title = entity.title
        movie.posterPath = entity.posterPath
        movie.backdropPath = entity.backdropPath
        movie.releaseDate = entity.releaseDate
        movie.overview = entity.overview
        movie.rating = NSNumber(value: entity.rating)
        entity.genres.forEach { (genre) in movie.appendGenre(GenreDB.fromEntity(genre)) }
        
        return movie
    }
    
    func toEntity() -> Movie {
        return Movie(
            id: self.id.intValue,
            title: self.title,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath,
            releaseDate: self.releaseDate,
            overview: self.overview,
            rating: self.rating.doubleValue,
            genres: self.genres.map({ $0 }).map({ $0.toEntity() })
        )
    }
}

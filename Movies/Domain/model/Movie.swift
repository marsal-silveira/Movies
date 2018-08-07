//
//  Movie.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

struct Movie {
    
    private(set) var id: Int
    private(set) var title: String
    private(set) var posterPath: String?
    private(set) var backdropPath: String?
    private(set) var releaseDate: String
    private(set) var overview: String
    private(set) var rating: Double
    private(set) var genres: [Genre]
    
    // calculated
    var genresStr: String {
        var result = self.genres.reduce("", { (old, genre) -> String in
            return old + genre.name + ", "
        })
        if result.contains(",") { result.removeLast(2) }
        return result
    }
    
    init(id: Int, title: String, posterPath: String?, backdropPath: String?, releaseDate: String, overview: String, rating: Double, genres: [Genre]) {
        
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.overview = overview
        self.rating = rating
        self.genres = genres
    }
    
    // poster | backdrop paths    
    func buildPosterPath() -> String? {
        return TMDbAPI.buildPosterPath(self.posterPath)
    }
    
    func buildBackdropPath() -> String? {
        return TMDbAPI.buildBackdropPath(self.backdropPath)
    }
}

// Decoder...
extension Movie {

    static func map(movieResult: MovieResultAPI, genres: [Genre]) -> Movie? {
        
        guard let id = movieResult.id,
              let title = movieResult.title,
              let overview = movieResult.overview,
              let rating = movieResult.rating,
              let releaseDate = movieResult.releaseDate,
              let genresIds = movieResult.genres else {
            return nil
        }
        
        let posterPath = movieResult.posterPath
        let backdropPath = movieResult.backdropPath
        
        let genresResult = genres.filter { (genre) -> Bool in
            return genresIds.contains(genre.id)
        }

        return Movie(id: id, title: title, posterPath: posterPath, backdropPath: backdropPath, releaseDate: releaseDate, overview: overview, rating: rating, genres: genresResult)
    }
    
    static func mapArray(moviesResult: [MovieResultAPI], genres: [Genre]) -> [Movie] {
        
        return moviesResult
            .map { map(movieResult: $0, genres: genres) }
            .filter { $0 != nil }
            .map { $0! }
    }
}

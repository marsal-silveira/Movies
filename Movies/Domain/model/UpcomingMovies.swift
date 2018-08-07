//
//  UpcomingMovies.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

class UpcomingMovies {
    
    private(set) var page: Int
    private(set) var totalPages: Int
    private(set) var movies: [Movie]
    
    init(page: Int, totalPages: Int, movies: [Movie]) {
        self.page = page
        self.totalPages = totalPages
        self.movies = movies
    }
}

// Decoder...
extension UpcomingMovies {
 
    static func map(upcomingMoviesResult: UpcomingMoviesResultAPI, genres: [Genre]) -> UpcomingMovies? {
        
        guard let page = upcomingMoviesResult.page,
              let totalPages = upcomingMoviesResult.totalPages,
              let moviesResult = upcomingMoviesResult.movies else {
            return nil
        }
        var movies: [Movie] = []
        for movieResult in moviesResult {
            if let movie = Movie.map(movieResult: movieResult, genres: genres) {
                movies.append(movie)
            }
        }
        return UpcomingMovies(page: page, totalPages: totalPages, movies: movies)
    }
}

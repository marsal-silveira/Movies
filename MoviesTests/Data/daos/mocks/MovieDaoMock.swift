//
//  MovieDaoMock.swift
//  MoviesTests
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import XCTest
import ObjectMapper

@testable import Movies

class MovieDaoMock {

    private var _movies: [Movie]

    init() {
        _movies = [
            Movie(id: 351286, title: "Jurassic World: Fallen Kingdom", posterPath: nil, backdropPath: nil, releaseDate: "2018-06-06", overview: "", rating: 0, genres: [Genre(id: 28, name: "Action"), Genre(id: 12, name: "Adventure"), Genre(id: 878, name: "Science Fiction")]),
            Movie(id: 447332, title: "A Quiet Place", posterPath: nil, backdropPath: nil, releaseDate: "2018-04-05", overview: "", rating: 7.3, genres: [Genre(id: 18, name: "Drama"), Genre(id: 27, name: "Horror"), Genre(id: 53, name: "Thriller"), Genre(id: 878, name: "Science Fiction"), Genre(id: 10751, name: "Family")]),
            Movie(id: 460019, title: "Truth or Dare", posterPath: nil, backdropPath: nil, releaseDate: "2018-04-12", overview: "", rating: 5.9, genres: [Genre(id: 53, name: "Thriller"), Genre(id: 27, name: "Horror")]),
            Movie(id: 371608, title: "The Strangers: Prey at Night", posterPath: nil, backdropPath: nil, releaseDate: "2018-03-07", overview: "", rating: 5.5, genres: [Genre(id: 27, name: "Horror"), Genre(id: 53, name: "Thriller")])
        ]
    }
}

extension MovieDaoMock: MovieDaoProtocol {
    
    func getAll() throws -> [Movie] {
        return _movies
    }
    
    func save(movies: [Movie]) throws {
        _movies.append(contentsOf: movies)
    }
    
    func clear() throws {
        _movies.removeAll()
    }
}

//
//  GenreDaoMock.swift
//  MoviesTests
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import XCTest
import ObjectMapper

@testable import Movies

class GenreDaoMock {
    
    private var _genres: [Genre]
    
    init() {
        _genres = [
            Genre(id: 28, name: "Action"),
            Genre(id: 12, name: "Adventure"),
            Genre(id: 16, name: "Animation"),
            Genre(id: 35, name: "Comedy"),
            Genre(id: 80, name: "Crime"),
            Genre(id: 99, name: "Documentary"),
            Genre(id: 18, name: "Drama"),
            Genre(id: 10751, name: "Family"),
            Genre(id: 14, name: "Fantasy"),
            Genre(id: 36, name: "History"),
            Genre(id: 27, name: "Horror"),
            Genre(id: 10402, name: "Music"),
            Genre(id: 9648, name: "Mystery"),
            Genre(id: 10749, name: "Romance"),
            Genre(id: 878, name: "Science Fiction"),
            Genre(id: 10770, name: "TV Movie"),
            Genre(id: 53, name: "Thriller"),
            Genre(id: 10752, name: "War"),
            Genre(id: 37, name: "Western")
        ]
    }
}

extension GenreDaoMock: GenreDaoProtocol {

    func getAll() throws -> [Genre] {
        return _genres
    }
    
    func save(genres: [Genre]) throws {
        _genres.append(contentsOf: genres)
    }
    
    func clear() throws {
        _genres.removeAll()
    }
}

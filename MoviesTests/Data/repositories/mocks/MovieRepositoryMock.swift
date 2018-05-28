//
//  GenreRepositoryMock.swift
//  MoviesTests
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

@testable import Movies

class MovieRepositoryMock: MovieRepositoryProtocol {
    
    private let _moviesMock: [[Movie]] = [
        // page 1
        [
            Movie(id: 351286, title: "Deadpool 2", posterPath: "", backdropPath: "", releaseDate: "2018-05-15", overview: "", rating: 8, genres: [Genre(id: 28, name: "Action")]),
            Movie(id: 401981, title: "Red Sparrow", posterPath: "", backdropPath: "", releaseDate: "2018-03-01", overview: "", rating: 6.4, genres: [Genre(id: 53, name: "Thriller")])
        ],
        // page 2
        [
            Movie(id: 351286, title: "Jurassic World: Fallen Kingdom", posterPath: "", backdropPath: "", releaseDate: "2018-06-06", overview: "", rating: 0, genres: [Genre(id: 28, name: "Action")]),
            Movie(id: 447332, title: "A Quiet Place", posterPath: "", backdropPath: "", releaseDate: "2018-04-05", overview: "", rating: 5.9, genres: [Genre(id: 32, name: "Comedy")])
        ]
    ]

    private var _upcomingMoviesResponse = Variable<RequestResponse<UpcomingMovies>>(.new)
    
    var upcomingMovies: Observable<RequestResponse<UpcomingMovies>> {
        return _upcomingMoviesResponse.asObservable()
    }
    
    func fetchUpcomingMovies(page: Int) {
        
        _upcomingMoviesResponse.value = .loading
        
        let movies = page == 1 ? _moviesMock[0] : _moviesMock[1]
        let upconigMovies = UpcomingMovies(page: page, totalPages: _moviesMock.count, movies: movies)
        _upcomingMoviesResponse.value = .success(upconigMovies)
    }
}

//
//  TMDbAPIMock.swift
//  MoviesTests
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import XCTest
import RxTest
import RxSwift
import RxCocoa
import ObjectMapper

@testable import Movies

struct TMDbAPIMock: TMDbAPIProtocol {
    
    // ************************************************
    // MARK: Movies
    // ************************************************
    
    private func upcomingMoviesFromJSON() -> UpcomingMoviesResultAPI? {
        return Mapper<UpcomingMoviesResultAPI>().map(JSON: JSONRepository.upcomingMovies)
    }
    
    func upcomingMovies(page: Int) -> Single<UpcomingMoviesResultAPI> {
        
        return Single<UpcomingMoviesResultAPI>.create { single in
            guard let upcomingMovies = self.upcomingMoviesFromJSON() else {
                single(.error(MoviesError.error(description: Strings.errorParsingJson())))
                return Disposables.create()
            }
            single(.success(upcomingMovies))
            return Disposables.create()
        }
    }
    
    // ************************************************
    // MARK: Genres
    // ************************************************
    
    private func genresFromJSON() -> [GenreResultAPI] {
        return Mapper<GenreResultAPI>().mapArray(JSONArray: JSONRepository.genres)
    }

    func genres() -> Single<[GenreResultAPI]> {

        return Single<[GenreResultAPI]>.create { single in
            let genres = self.genresFromJSON()
            single(.success(genres))
            return Disposables.create()
        }
    }
}

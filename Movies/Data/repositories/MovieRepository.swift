//
//  MovieRepository.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieRepositoryProtocol {
    var upcomingMovies: Observable<RequestResponse<UpcomingMovies>> { get }
    func fetchUpcomingMovies(page: Int)
}

class MovieRepository: BaseRepository {

    private let _TMDbAPI: TMDbAPIProtocol
    private let _dao: MovieDaoProtocol

    private var _upcomingMoviesResponse = Variable<RequestResponse<UpcomingMovies>>(.new)
    private var _genres: [Genre] = []

    private var _disposeBag = DisposeBag()

    init(tMDbAPI: TMDbAPIProtocol, dao: MovieDaoProtocol, genreRepository: GenreRepositoryProtocol) {
        _TMDbAPI = tMDbAPI
        _dao = dao
        _genres = genreRepository.getAllGenres()

        super.init()
    }

    // *************************************************
    // MARK: - API
    // *************************************************

    private func fetchUpcomingMoviesFromAPI(page: Int) {

        _TMDbAPI.upcomingMovies(page: page)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }

                switch event {
                case .success(let upcomingMoviesResult):
                    guard let upcomingMovies = UpcomingMovies.map(upcomingMoviesResult: upcomingMoviesResult, genres: strongSelf._genres) else { fatalError() }

                    // save movies into local storage and send response
                    do {
                        try strongSelf.saveMoviesLocalStorage(movies: upcomingMovies.movies, clear: page == 1)
                        strongSelf._upcomingMoviesResponse.value = .success(upcomingMovies)
                    } catch let error {
                        strongSelf._upcomingMoviesResponse.value = .failure(error)
                    }

                case .error(let error):
                    strongSelf._upcomingMoviesResponse.value = .failure(error)
                }
            }
            .disposed(by: _disposeBag)
    }

    // *************************************************
    // MARK: - Local Stogare
    // *************************************************

    private func fetchUpcomingMoviesFromLocalStorage(page: Int) {

        do {
            let movies = try _dao.getAll()
            let upconigMovies = UpcomingMovies(page: page, totalPages: 1, movies: movies)
            _upcomingMoviesResponse.value = .success(upconigMovies)
        } catch let error {
            _upcomingMoviesResponse.value = .failure(error)
        }
    }

    private func saveMoviesLocalStorage(movies: [Movie], clear: Bool) throws {

        if clear {
            try _dao.clear()
        }
        try _dao.save(movies: movies)
    }
}

// *************************************************
// MARK: - MovieRepositoryProtocol
// *************************************************

extension MovieRepository: MovieRepositoryProtocol {

    var upcomingMovies: Observable<RequestResponse<UpcomingMovies>> {
        return _upcomingMoviesResponse.asObservable()
    }

    func fetchUpcomingMovies(page: Int) {

        _upcomingMoviesResponse.value = .loading

        if NetworkManager.shared.isReachable {
            self.fetchUpcomingMoviesFromAPI(page: page)
        } else {
            self.fetchUpcomingMoviesFromLocalStorage(page: page)
        }
    }
}

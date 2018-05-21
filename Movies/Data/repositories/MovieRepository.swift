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

    fileprivate let _TMDbAPI: TMDbAPIProtocol
    fileprivate var _upcomingMoviesResponse = BehaviorRelay<RequestResponse<UpcomingMovies>>(value: .new)
    
    private let _genreRepository: GenreRepositoryProtocol
    private var _genres: [Genre] = []
    
    fileprivate var _disposeBag = DisposeBag()

    init(tMDbAPI: TMDbAPIProtocol, genreRepository: GenreRepositoryProtocol) {
        _TMDbAPI = tMDbAPI
        _genreRepository = genreRepository
        
        super.init()
        self.bind()
    }
    
    private func bind() {
     
        _genreRepository
            .genres
            .bind {[weak self] (response) in
                guard let strongSelf = self else { return }
                
                switch response {
                    
                case .loading:
                    strongSelf._upcomingMoviesResponse.accept(.loading)
                    
                case .success(let genres):
                    strongSelf._genres = genres
                    strongSelf.fetchUpcomingMovies(page: 1)
                    
                case .failure(let error):
                    strongSelf._upcomingMoviesResponse.accept(.failure(error))
                    
                default:
                    break
                }
            }
            .disposed(by: _disposeBag)
    }
}

extension MovieRepository: MovieRepositoryProtocol {

    var upcomingMovies: Observable<RequestResponse<UpcomingMovies>> {
        return _upcomingMoviesResponse.asObservable()
    }

    func fetchUpcomingMovies(page: Int) {
        
        // if is first load... fetch genres before
        if _genres.isEmpty {
            _genreRepository.fetchGenres()
            return
        }

        _upcomingMoviesResponse.accept(.loading)
        
        _TMDbAPI.upcomingMovies(page: page)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event {
                case .success(let upcomingMoviesResult):
                    guard let upcomingMovies = UpcomingMovies.map(upcomingMoviesResult: upcomingMoviesResult, genres: strongSelf._genres) else { fatalError() }
                    strongSelf._upcomingMoviesResponse.accept(.success(upcomingMovies))
                    
                case .error(let error):
                    strongSelf._upcomingMoviesResponse.accept(.failure(error))
                }
            }
            .disposed(by: _disposeBag)
    }
}

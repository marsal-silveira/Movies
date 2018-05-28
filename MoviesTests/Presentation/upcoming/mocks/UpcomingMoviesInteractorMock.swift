//
//  UpcomingMoviesInteractorMock.swift
//  MoviesTests
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

@testable import Movies

class UpcomingMoviesInteractorMock: BaseInteractor {
    
    private let _repository: MovieRepositoryProtocol
    private var _disposeBag = DisposeBag()
    
    private var _moviesResponse = Variable<RequestResponse<[Movie]>>(.new)
    
    private var _movies = [Movie]()
    private var _totalPages: Int = 0
    private var _currentPage: Int = 0
    
    override init() {
        _repository = MovieRepositoryMock()
        super.init()
        self.bind()
    }
    
    private func bind() {
        
        _repository
            .upcomingMovies
            .bind {[weak self] (response) in
                guard let strongSelf = self else { return }
                
                switch response {
                    
                case .loading:
                    strongSelf._moviesResponse.value = .loading
                    
                case .success(let upcomingMovies):
                    strongSelf._totalPages = upcomingMovies.totalPages
                    strongSelf._currentPage = upcomingMovies.page
                    strongSelf._movies.append(contentsOf: upcomingMovies.movies)
                    strongSelf._moviesResponse.value = .success(strongSelf._movies)
                    
                case .failure(let error):
                    strongSelf._moviesResponse.value = .failure(error)
                    
                default:
                    break
                }
            }
            .disposed(by: _disposeBag)
    }
}

extension UpcomingMoviesInteractorMock: UpcomingMoviesInteractorProtocol {
    
    var movies: Driver<RequestResponse<[Movie]>> {
        return _moviesResponse.asDriver()
    }
    
    func fetchMovies(reset: Bool) {
        
        if reset {
            _movies.removeAll()
            _currentPage = 0
            _totalPages = 0
        }
        
        // only continue if has pages to be fetched...
        let nextPage = _currentPage+1
        if (nextPage == 1) || (nextPage <= _totalPages) {
            _repository.fetchUpcomingMovies(page: nextPage)
        }
    }
}

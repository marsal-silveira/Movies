//
//  UpcomingMoviesPresenter.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// Value Object to be used in view
struct UpcomingMovieVO {
    
    private(set) var id: Int
    private(set) var posterPath: String?
    private(set) var title: String
    private(set) var genres: String
    private(set) var releaseDate: String
    private(set) var rating: String
    
    init(id: Int, posterPath: String?, title: String, genres: String, releaseDate: String, rating: String) {
        self.id = id
        self.posterPath = posterPath
        self.title = title
        self.genres = genres
        self.releaseDate = releaseDate
        self.rating = rating
    }
}

protocol UpcomingMoviesPresenterProtocol: BasePresenterProtocol {

    var router: UpcomingMoviesRouterProtocol? { get set }
    var movies: Observable<[UpcomingMovieVO]> { get }
    
    func fetchMovies(reset: Bool)
    
    func didSelectMovie(_ movie: UpcomingMovieVO)
}

class UpcomingMoviesPresenter: BasePresenter {
    
    // internal
    private let _interactor: UpcomingMoviesInteractorProtocol
    private let _disposeBag = DisposeBag()
    
    private var _movies = BehaviorRelay<[Movie]>(value: [])
    private var _showLoading = true

    // public
    public weak var router: UpcomingMoviesRouterProtocol?
    
    init(interactor: UpcomingMoviesInteractorProtocol) {
    
        _interactor = interactor
        
        super.init()
        bind()
    }

    private func bind() {

        _interactor.movies
            .bind {[weak self] (response) in
                guard let strongSelf = self else { return }

                switch response {

                case .loading:
                    if strongSelf._showLoading {
                        strongSelf._viewState.accept(.loading(LoadingViewModel(text: Strings.placeholderLoading())))
                    }

                case .success(let movies):
                    strongSelf._viewState.accept(.normal)
                    strongSelf._movies.accept(movies)

                case .failure(let error):
                    let placeholderViewModel = ErrorViewModel(text: Strings.errorDefault(), details: error.localizedDescription)
                    strongSelf._viewState.accept(.error(placeholderViewModel))

                default:
                    break
                }
            }
            .disposed(by: _disposeBag)
    }
}

extension UpcomingMoviesPresenter: UpcomingMoviesPresenterProtocol {
    
    var movies: Observable<[UpcomingMovieVO]> {

        return _movies
            .asObservable()
            .flatMap { (movies) -> Observable<[UpcomingMovieVO]> in

                let mm = movies.map { (movie) -> UpcomingMovieVO in
                    
                    // TODO: Check this... call TMDbAPI from here looks like strange :|
                    let posterPath = movie.posterPath != nil ? "\(TMDbAPI.posterBasePath)\(movie.posterPath!)" : nil
                    let rating = "★ \(movie.rating)"
                    return UpcomingMovieVO(id: movie.id, posterPath: posterPath, title: movie.title, genres: movie.genresStr, releaseDate: movie.releaseDate, rating: rating)
                }
                return Observable.just(mm)
            }
    }

    func fetchMovies(reset: Bool = false) {
        _showLoading = reset
        _interactor.fetchMovies(reset: reset)
    }
    
    func didSelectMovie(_ movie: UpcomingMovieVO) {
        
        guard let selectedMovie = _movies.value.filter({ (m) -> Bool in return m.id == movie.id }).first else {
            let placeholderViewModel = ErrorViewModel(text: Strings.errorDefault(), details: Strings.upcomingMoviesMovieNotFound())
            _viewState.accept(.error(placeholderViewModel))
            return
        }
        router?.showDetails(for: selectedMovie)
    }
}

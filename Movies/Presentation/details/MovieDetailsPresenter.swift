//
//  MovieDetailsPresenter.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// Value Object to be used in view
struct MovieDetailsVO {
    
    private(set) var backdropPath: String?
    private(set) var title: String
    private(set) var rating: String
    private(set) var releaseDate: String
    private(set) var genre: String
    private(set) var overview: String
    
    init(backdropPath: String?, title: String, rating: String, releaseDate: String, genre: String, overview: String) {
        self.backdropPath = backdropPath
        self.title = title
        self.rating = rating
        self.releaseDate = releaseDate
        self.genre = genre
        self.overview = overview
    }
}

protocol MovieDetailsPresenterProtocol: BasePresenterProtocol {

    var router: MovieDetailsRouterProtocol? { get set }
    var movie: Driver<MovieDetailsVO> { get }
}

class MovieDetailsPresenter: BasePresenter {
    
    // internal
    private let _interactor: MovieDetailsInteractorProtocol
    private let _disposeBag = DisposeBag()
    
    // public
    public weak var router: MovieDetailsRouterProtocol?
    
    init(interactor: MovieDetailsInteractorProtocol) {
    
        _interactor = interactor
        super.init()
    }
}

extension MovieDetailsPresenter: MovieDetailsPresenterProtocol {
    
    var movie: Driver<MovieDetailsVO> {

        return _interactor
            .movie
            .flatMap { (movie) -> Driver<MovieDetailsVO> in
                
                let backdropPath = movie.buildBackdropPath()
                let rating = "★ \(movie.rating)"
                let releaseDate = movie.releaseDate
                let movieDetails = MovieDetailsVO(backdropPath: backdropPath, title: movie.title, rating: rating, releaseDate: releaseDate, genre: movie.genresStr, overview: movie.overview)
                return Driver.just(movieDetails)
            }
    }
}

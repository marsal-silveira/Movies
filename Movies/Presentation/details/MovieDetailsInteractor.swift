//
//  MovieDetailsInteractor.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieDetailsInteractorProtocol {
    var movie: Driver<Movie> { get }
}

class MovieDetailsInteractor: BaseInteractor {

    private var _movie: Variable<Movie>
    
    init(movie: Movie) {

        _movie = Variable<Movie>(movie)
        super.init()
    }
}

extension MovieDetailsInteractor: MovieDetailsInteractorProtocol {
    
    var movie: Driver<Movie> {
        return _movie.asDriver()
    }
}

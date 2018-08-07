//
//  UpcomingMoviesRouter.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import UIKit
import RxCocoa

protocol UpcomingMoviesRouterProtocol: class {
    func showDetails(for movie: Movie)
}

class UpcomingMoviesRouter: BaseRouter {
    
    private let _navigationController: BaseNavigationController
    private let _viewController: UpcomingMoviesViewController
    private var _presenter: UpcomingMoviesPresenterProtocol
    
    var viewController: UIViewController {
        return _navigationController
    }
    
    override init() {

        let genreRepository = GenreRepository(tMDbAPI: TMDbAPI(), dao: GenreDao())
        let movieRepository = MovieRepository(tMDbAPI: TMDbAPI(), dao: MovieDao(), genreRepository: genreRepository)
        let interactor = UpcomingMoviesInteractor(repository: movieRepository)
        
        _presenter = UpcomingMoviesPresenter(interactor: interactor)
        _viewController = UpcomingMoviesViewController(presenter: _presenter)
        _navigationController = BaseNavigationController(rootViewController: _viewController)

        super.init()
        
        _presenter.router = self
        self.bind()
    }
    
    private func bind() {
        _ = _navigationController.rx
            .didShow
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] (viewController, _) in
                guard let strongSelf = self else { return }
                
                if strongSelf._viewController === viewController {
                    strongSelf.presentedRouter = nil
                }
            })
    }
}

extension UpcomingMoviesRouter: UpcomingMoviesRouterProtocol {

    func showDetails(for movie: Movie) {
        let movieDetailsRouter = MovieDetailsRouter(movie: movie)
        movieDetailsRouter.present(on: _navigationController)
        self.presentedRouter = movieDetailsRouter
    }
}

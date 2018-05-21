//
//  MovieDetailsRouter.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import UIKit
import RxCocoa

protocol MovieDetailsRouterProtocol: class {

}

class MovieDetailsRouter: BaseRouter {
    
    private var _navigationController: BaseNavigationController?
    private let _viewController: MovieDetailsViewController
    private var _presenter: MovieDetailsPresenterProtocol

    init(movie: Movie) {
        
        let interactor = MovieDetailsInteractor(movie: movie)
        _presenter = MovieDetailsPresenter(interactor: interactor)
        _viewController = MovieDetailsViewController(presenter: _presenter)
        _navigationController = BaseNavigationController(rootViewController: _viewController)
        
        super.init()
        
        _presenter.router = self
    }
    
    private func bind() {
        _ = _navigationController?.rx
            .didShow
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] (viewController, _) in
                guard let strongSelf = self else { return }
                
                if strongSelf._viewController === viewController {
                    strongSelf.presentedRouter = nil
                }
            })
    }
    
    func present(on navigationController: BaseNavigationController) {

        navigationController.pushViewController(_viewController, animated: true)
        _navigationController = navigationController
        self.bind()
    }
}

extension MovieDetailsRouter: MovieDetailsRouterProtocol {

}

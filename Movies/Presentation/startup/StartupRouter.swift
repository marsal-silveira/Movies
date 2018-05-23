//
//  StartupRouter.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import UIKit
import RxCocoa

protocol StartupRouterProtocol: class {
    func showUpcommingMovies()
}

class StartupRouter: BaseRouter {
    
    private let _viewController: StartupViewController
    private var _presenter: StartupPresenterProtocol

    override init() {
        
        let interactor = StartupInteractor(genreRepository: GenreRepository(tMDbAPI: TMDbAPI(), dao: GenreDao()))
        _presenter = StartupPresenter(interactor: interactor)
        _viewController = StartupViewController(presenter: _presenter)
        
        super.init()
        
        _presenter.router = self
    }
    
    var viewController: UIViewController { return _viewController }
}

extension StartupRouter: StartupRouterProtocol {
    
    func showUpcommingMovies() {
        AppDelegate.shared.container?.updateCurrentScreen(Container.Screen.upcomingMovies)
    }
}

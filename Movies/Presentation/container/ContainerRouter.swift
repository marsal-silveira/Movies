//
//  ContainerRouter.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum ContentScreen {
    case home
}

protocol ContainerRouterProtocol: class {
    func updateCurrentScreen(_ screen: ContentScreen)
}

class ContainerRouter: BaseRouter {
    
    private let _viewController: ContainerViewController
    private let _presenter: ContainerPresenterProtocol
    private var _childRouter: BaseRouter?
    
    private let _disposeBag = DisposeBag()
    private var _currentScreen: ContentScreen?
    
    override init() {
        
        _presenter = ContainerPresenter()
        _viewController = ContainerViewController(presenter: _presenter)

        super.init()
    }
    
    func presentOn(window: UIWindow) {
        
        window.rootViewController = _viewController
        window.makeKeyAndVisible()
        
        // fixed because we have only one possible screen... if we have a session we can change the VC in show automatically just changing current screen value
        self.updateCurrentScreen(.home)
    }
}

extension ContainerRouter: ContainerRouterProtocol {
    
    func updateCurrentScreen(_ screen: ContentScreen) {
        
        guard screen != _currentScreen else { return }
//        switch screen {
//
//        case .home:
//            let upcomingMoviesRouter = UpcomingMoviesRouter()
//            _viewController.setCurrentViewController(upcomingMoviesRouter.viewController)
//            _childRouter = upcomingMoviesRouter
//        }
        
        _viewController.setCurrentViewController(ViewController(nibName: nil, bundle: nil))
        
        _currentScreen = screen
    }
}

// TODO: to remove...
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .blue
    }
}

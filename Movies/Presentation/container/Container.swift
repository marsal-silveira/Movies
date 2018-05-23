//
//  Container.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit
import Cartography

/*
 * Container is the place where the current view controller will be showed
 */
class Container: UIViewController {
    
    // *************************************************
    // MARK: - Screen
    // *************************************************
    
    enum Screen {
        case startup
        case upcomingMovies
    }
    
    // *************************************************
    // MARK: - Factory
    // *************************************************
    
    static func present(on window: UIWindow) {
        
        let viewController = Container()
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        // initil screen
        viewController.updateCurrentScreen(.startup)
    }
    
    // *************************************************
    // MARK: - Properties
    // *************************************************
    
    // this is necessary to retain the current router reference... without this the presented router will be released from memory
    private var _currentRouter: BaseRouter?
    
    private var _currentViewController: UIViewController? {
        
        didSet {
            if let currentViewController = _currentViewController {
                
                currentViewController.willMove(toParentViewController: self)
                addChildViewController(currentViewController)
                currentViewController.didMove(toParentViewController: self)
                
                if let oldViewController = oldValue {
                    view.insertSubview(currentViewController.view, belowSubview: oldViewController.view)
                } else {
                    view.addSubview(currentViewController.view)
                }
                
                constrain(currentViewController.view, view, block: { (childView, parentView) in
                    childView.edges == parentView.edges
                })
                
                self.setNeedsStatusBarAppearanceUpdate()
            }
            
            if let oldViewController = oldValue {
                self.applyScreenTransition(newViewController: _currentViewController, oldViewController: oldViewController)
            }
        }
    }
    
    // *************************************************
    // MARK: - Lifecycle
    // *************************************************
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let currentViewController = _currentViewController else {
            return .lightContent
        }
        return currentViewController.preferredStatusBarStyle
    }
    
    // *************************************************
    // MARK: - Screen
    // *************************************************
    
    private var _currentScreen: Screen?
    
    func updateCurrentScreen(_ screen: Screen) {
        
        guard screen != _currentScreen else { return }
        switch screen {
            
        case .startup:
            let startupRouter = StartupRouter()
            _currentRouter = startupRouter
            _currentViewController = startupRouter.viewController
            
        case .upcomingMovies:
            let upcomingMoviesRouter = UpcomingMoviesRouter()
            _currentRouter = upcomingMoviesRouter
            _currentViewController = upcomingMoviesRouter.viewController
        }

        _currentScreen = screen
    }
    
    // *************************************************
    // MARK: - VC Transition
    // *************************************************
    
    private func applyScreenTransition(newViewController: UIViewController?, oldViewController: UIViewController) {
        
        if let newViewController = newViewController {
            
            newViewController.view.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.size.height))
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: {
                newViewController.view.transform = CGAffineTransform.identity
                oldViewController.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
            }, completion: { (finished) in
                oldViewController.removeDefinitely()
            })
        } else {
            oldViewController.removeDefinitely()
        }
    }
}

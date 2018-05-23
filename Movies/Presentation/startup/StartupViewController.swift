//
//  StartupViewController.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class StartupViewController: BaseViewController {

    // ************************************************
    // MARK: Properties
    // ************************************************
    
    private var _presenter: StartupPresenterProtocol {
        return basePresenter as! StartupPresenterProtocol
    }
    
    fileprivate var _disposeBag = DisposeBag()
    
    // ************************************************
    // MARK: UIViewController Init | Lifecycle
    // ************************************************
    
    init(presenter: BasePresenterProtocol) {
        super.init(presenter: presenter, nibName: Nibs.startupViewController.name)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // ************************************************
    // MARK: Setup
    // ************************************************
    
    override func setupOnLoad() {
        super.setupOnLoad()

        _presenter.fetchInitialData()
    }
}

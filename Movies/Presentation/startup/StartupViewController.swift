//
//  StartupViewController.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit

class StartupViewController: BaseViewController {

    // ************************************************
    // MARK: Properties
    // ************************************************
    
    override class var NibName: String? {
        return Nibs.startupViewController.name
    }
    
    private var _presenter: StartupPresenterProtocol {
        return basePresenter as! StartupPresenterProtocol
    }
    
    // ************************************************
    // MARK: Setup
    // ************************************************
    
    override func setupOnLoad() {
        super.setupOnLoad()
        _presenter.fetchInitialData()
    }
}

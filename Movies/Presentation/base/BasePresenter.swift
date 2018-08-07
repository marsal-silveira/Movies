//
//  BasePresenter.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum ViewState {
    case normal
    case loading(LoadingViewModel)
    case error(ErrorViewModel)
}

protocol BasePresenterProtocol {
    var viewState: Driver<ViewState> { get }
}

class BasePresenter {
    
    internal let _viewState = Variable<ViewState>(.normal)

    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}

extension BasePresenter: BasePresenterProtocol {
    
    var viewState: Driver<ViewState> {
        return _viewState.asDriver()
    }
}

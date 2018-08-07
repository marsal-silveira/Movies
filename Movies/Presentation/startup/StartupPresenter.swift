//
//  StartupPresenter.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol StartupPresenterProtocol: BasePresenterProtocol {
    var router: StartupRouterProtocol? { get set }
    func fetchInitialData()
}

class StartupPresenter: BasePresenter {
    
    private let _interactor: StartupInteractorProtocol
    private let _disposeBag = DisposeBag()
    
    var router: StartupRouterProtocol?
    
    init(interactor: StartupInteractorProtocol) {
        _interactor = interactor
        super.init()
        self.bind()
    }
    
    private func bind() {
        
        _interactor.isDone
            .drive(onNext: { [weak self] (response) in
                guard let strongSelf = self else { return }
                
                switch response {
                    
                case .loading:
                    strongSelf._viewState.value = .loading(LoadingViewModel(text: Strings.placeholderLoading()))
                    
                case .success:
                    strongSelf._viewState.value = .normal
                    strongSelf.router?.showUpcommingMovies()
                    
                case .failure(let error):
                    let placeholderViewModel = ErrorViewModel(text: Strings.errorDefault(), details: error.localizedDescription)
                    strongSelf._viewState.value = .error(placeholderViewModel)
                    
                default:
                    break
                }
            })
            .disposed(by: _disposeBag)
    }
}

extension StartupPresenter: StartupPresenterProtocol {

    func fetchInitialData() {
        _interactor.fetchInitialData()
    }
}

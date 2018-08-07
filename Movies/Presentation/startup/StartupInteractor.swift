//
//  StartupInteractor.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol StartupInteractorProtocol {
    var isDone: Driver<RequestResponse<Void>> { get }
    func fetchInitialData()
}

class StartupInteractor: BaseInteractor {
    
    private let _genreRepository: GenreRepositoryProtocol
    private var _disposeBag = DisposeBag()

    private var _isDone = Variable<RequestResponse<Void>>(.new)

    init(genreRepository: GenreRepositoryProtocol) {
        _genreRepository = genreRepository
        super.init()
        self.bind()
    }
    
    private func bind() {
        
        _genreRepository
            .genres
            .bind { [weak self] (response) in
                guard let strongSelf = self else { return }
                
                switch response {
                    
                case .loading:
                    strongSelf._isDone.value = .loading

                case .success:
                    strongSelf._isDone.value = .success(())

                case .failure(let error):
                    strongSelf._isDone.value = .failure(error)

                default:
                    break
                }
            }
            .disposed(by: _disposeBag)
    }
}

extension StartupInteractor: StartupInteractorProtocol {
    
    var isDone: Driver<RequestResponse<Void>> {
        return _isDone.asDriver()
    }
    
    func fetchInitialData() {
        _genreRepository.fetchGenres()
    }
}

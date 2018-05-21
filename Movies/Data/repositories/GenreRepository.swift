//
//  GenreRepository.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol GenreRepositoryProtocol {
    
    var genres: Observable<RequestResponse<[Genre]>> { get }
    func fetchGenres()
    func getGenres(byIds ids: [Int]) -> [Genre]
}

class GenreRepository: BaseRepository {
    
    fileprivate let _TMDbAPI: TMDbAPIProtocol
    fileprivate var _genresResponse = BehaviorRelay<RequestResponse<[Genre]>>(value: .new)
    fileprivate var _genres: [Genre] = []
    
    fileprivate var _disposeBag = DisposeBag()
    
    init(tMDbAPI: TMDbAPIProtocol) {
        _TMDbAPI = tMDbAPI
    }
}

extension GenreRepository: GenreRepositoryProtocol {
    
    var genres: Observable<RequestResponse<[Genre]>> {
        return _genresResponse.asObservable()
    }
    
    func fetchGenres() {
        
        _genresResponse.accept(.loading)
        
        _TMDbAPI.genres()
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }

                switch event {
                case .success(let genresResult):
                    let genres = Genre.mapArray(genresResult: genresResult)
                    strongSelf._genresResponse.accept(.success(genres))

                case .error(let error):
                    strongSelf._genresResponse.accept(.failure(error))
                }
            }
            .disposed(by: _disposeBag)
    }
    
    func getGenres(byIds ids: [Int]) -> [Genre] {
        
        return _genres.filter({ (genre) -> Bool in
            return ids.contains(genre.id)
        })
    }
}

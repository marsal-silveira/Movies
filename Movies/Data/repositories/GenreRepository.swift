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
    
    private let _TMDbAPI: TMDbAPIProtocol
    private let _dao: GenreDaoProtocol
    
    private var _genresResponse = BehaviorRelay<RequestResponse<[Genre]>>(value: .new)
    private var _genres: [Genre] = []
    
    private var _disposeBag = DisposeBag()
    
    init(tMDbAPI: TMDbAPIProtocol, dao: GenreDaoProtocol) {
        _TMDbAPI = tMDbAPI
        _dao = dao
        
        super.init()
    }
    
    // *************************************************
    // MARK: - API
    // *************************************************
    
    private func fetchGenresFromAPI() {
        
        _TMDbAPI.genres()
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event {
                case .success(let genresResult):
                    let genres = Genre.mapArray(genresResult: genresResult)
                    
                    // save genres into local storage and send response
                    do {
                        try strongSelf.saveGenresLocalStorage(genres: genres)
                        strongSelf._genresResponse.accept(.success(genres))
                    } catch let error {
                        strongSelf._genresResponse.accept(.failure(error))
                    }
                    
                case .error(let error):
                    strongSelf._genresResponse.accept(.failure(error))
                }
            }
            .disposed(by: _disposeBag)
    }
    
    // *************************************************
    // MARK: - Local Storage
    // *************************************************
    
    private func fetchGenresFromLocalStorage() {
        
        do {
            let genres = try _dao.getAll()
            _genresResponse.accept(.success(genres))
        } catch let error {
            _genresResponse.accept(.failure(error))
        }
    }
    
    private func saveGenresLocalStorage(genres: [Genre]) throws {
        
        try _dao.clear()
        try _dao.save(genres: genres)
    }
}

// *************************************************
// MARK: - GenreRepositoryProtocol
// *************************************************

extension GenreRepository: GenreRepositoryProtocol {
    
    var genres: Observable<RequestResponse<[Genre]>> {
        return _genresResponse.asObservable()
    }
    
    func fetchGenres() {
        
        _genresResponse.accept(.loading)
        
        if NetworkManager.shared.isReachable {
            self.fetchGenresFromAPI()
        } else {
            self.fetchGenresFromLocalStorage()
        }
    }
    
    func getGenres(byIds ids: [Int]) -> [Genre] {
        
        return _genres.filter({ (genre) -> Bool in
            return ids.contains(genre.id)
        })
    }
}

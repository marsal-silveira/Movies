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
    func getAllGenres() -> [Genre]
}

class GenreRepository: BaseRepository {
    
    private let _TMDbAPI: TMDbAPIProtocol
    private let _dao: GenreDaoProtocol
    
    private var _genres = Variable<RequestResponse<[Genre]>>(.new)

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
                        strongSelf._genres.value = .success(genres)
                    } catch let error {
                        strongSelf._genres.value = .failure(error)
                    }
                    
                case .error(let error):
                    strongSelf._genres.value = .failure(error)
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
            _genres.value = .success(genres)
        } catch let error {
            _genres.value = .failure(error)
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
        return _genres.asObservable()
    }
    
    func fetchGenres() {
        
        _genres.value = .loading
        
        if NetworkManager.shared.isReachable {
            self.fetchGenresFromAPI()
        } else {
            self.fetchGenresFromLocalStorage()
        }
    }
    
    /// get genres from local storage...
    func getAllGenres() -> [Genre] {
        do {
            return try _dao.getAll()
        } catch let error {
            print("error getting genres. \(error.localizedDescription)")
            return []
        }
    }
}

//
//  StartupInteractorTests.swift
//  MoviesTests
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
@testable import Movies

class StartupInteractorTests: XCTestCase {
    
    private var _interactor: StartupInteractorProtocol?
    
    override func setUp() {
        super.setUp()
        print("setUp()")
        
        _interactor = StartupInteractor(genreRepository: GenreRepositoryMock())
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown()")
        
        _interactor = nil
    }
    
    func testAllGenres() {
//        let genres = _interactor?.
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class GenreRepositoryMock: GenreRepositoryProtocol {
    
    var genres: Observable<RequestResponse<[Genre]>> {
        let result = [Genre(id: 1, name: "Action"), Genre(id: 2, name: "Comedy")]
        return Observable.from(optional: .success(result))
    }
    
    func fetchGenres() {
        
//        _genresResponse.value = .loading
//
//        if NetworkManager.shared.isReachable {
//            self.fetchGenresFromAPI()
//        } else {
//            self.fetchGenresFromLocalStorage()
//        }
    }
    
    func getAllGenres() -> [Genre] {
        return [Genre(id: 1, name: "Action"), Genre(id: 2, name: "Comedy")]
    }
    
    func getGenres(byIds ids: [Int]) -> [Genre] {
        let result = [Genre(id: 1, name: "Action"), Genre(id: 2, name: "Comedy")]
        return result.filter({ (genre) -> Bool in
            return ids.contains(genre.id)
        })
    }
}

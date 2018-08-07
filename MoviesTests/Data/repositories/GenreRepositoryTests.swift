//
//  GenreRepositoryTests.swift
//  MoviesTests
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
import RxTest

@testable import Movies

class GenreRepositoryTests: XCTestCase {
    
    private var _disposeBag: DisposeBag!
    private var _scheduler: TestScheduler!
    private var _repository: GenreRepositoryProtocol!
    
    override func setUp() {
        super.setUp()
        
        _disposeBag = DisposeBag()
        _scheduler = TestScheduler(initialClock: 0)
        _repository = GenreRepository(tMDbAPI: TMDbAPIMock(), dao: GenreDaoMock())
    }
    
    override func tearDown() {
        super.tearDown()
        
        _disposeBag = nil
        _scheduler = nil
        _repository = nil
    }
    
    private func log(message: String) {
        print("\(String(describing: self)) >> \(message)")
    }

    func test_allGenres() {
        self.log(message: "[START]")
        
        let observer = _scheduler.createObserver(RequestResponse<[Genre]>.self)
        _repository.genres.asDriver(onErrorJustReturn: .failure(MoviesError.error(description: "TODO:"))).drive(observer).disposed(by: _disposeBag)
        _repository.fetchGenres()
        
        // 1
        observer.events.forEach { (event) in

            let response = event.value.element ?? .new
            switch response {
            case .success(let genres):
                self.log(message: "genres >> \(genres.count)")
                XCTAssert(genres.count == 19)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            default:
                return
            }
        }
        
        // 2
        let genres = _repository.getAllGenres()
        XCTAssert(genres.count == 19)

        self.log(message: "[END]")
    }
}

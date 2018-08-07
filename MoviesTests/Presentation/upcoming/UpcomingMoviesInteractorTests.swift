//
//  UpcomingMoviesInteractorTests.swift
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

class UpcomingMoviesInteractorTests: XCTestCase {

    private var _disposeBag: DisposeBag!
    private var _scheduler: TestScheduler!
    private var _interactor: UpcomingMoviesInteractorProtocol!

    override func setUp() {
        super.setUp()

        _disposeBag = DisposeBag()
        _scheduler = TestScheduler(initialClock: 0)
        _interactor = UpcomingMoviesInteractor(repository: MovieRepositoryMock())
    }

    override func tearDown() {
        super.tearDown()

        _disposeBag = nil
        _scheduler = nil
        _interactor = nil
    }
    
    private func log(message: String) {
        print("\(String(describing: self)) >> \(message)")
    }

    func test_movies() {
        self.log(message: "[START]")

        let observer = _scheduler.createObserver(RequestResponse<[Movie]>.self)
        _interactor.movies.drive(observer).disposed(by: _disposeBag)
        
        _interactor.fetchMovies(reset: true) // page 1
        _interactor.fetchMovies(reset: false) // page 2
        _interactor.fetchMovies(reset: false) // page 3 -- do nothing
        
        var page_ = 0
        observer.events.forEach { (event) in

            let response = event.value.element ?? .new
            switch response {
            case .success(let movies):
                page_ += 1
                self.log(message: "page#\(page_) >> \(movies.count)")
                XCTAssert(movies.count == (2 * page_))
            case .failure(let error):
                XCTFail(error.localizedDescription)
            default:
                return
            }
        }

        self.log(message: "[START]")
    }
}

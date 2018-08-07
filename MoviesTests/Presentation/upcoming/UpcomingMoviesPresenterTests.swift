//
//  UpcomingMoviesPresenter.swift
//  Movies
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

class UpcomingMoviesPresenterTests: XCTestCase {
    
    private var _disposeBag: DisposeBag!
    private var _scheduler: TestScheduler!

    private var _presenter: UpcomingMoviesPresenterProtocol!
    
    override func setUp() {
        super.setUp()
        
        _disposeBag = DisposeBag()
        _scheduler = TestScheduler(initialClock: 0)
        _presenter = UpcomingMoviesPresenter(interactor: UpcomingMoviesInteractor(repository: MovieRepositoryMock()))
    }
    
    override func tearDown() {
        super.tearDown()
        
        _disposeBag = nil
        _scheduler = nil
        _presenter = nil
    }
    
    private func log(message: String) {
        print("\(String(describing: self)) >> \(message)")
    }

    func test_movies() throws {
        self.log(message: "[START]")

        let observer = _scheduler.createObserver([UpcomingMovieVO].self)
        _presenter.movies.drive(observer).disposed(by: _disposeBag)

        _presenter.fetchMovies(reset: true) // page 1
        _presenter.fetchMovies(reset: false) // page 2
        _presenter.fetchMovies(reset: false) // page 3 -- do nothing

        // test pages
        var page_ = 0
        observer.events.forEach { (event) in
            
            page_ += 1
            let movies = event.value.element ?? []
            self.log(message: "page#\(page_) >> \(movies.count)")
            XCTAssert(movies.count == (2 * (page_ - 1)))
        }
        
        // test all movies
        guard let movies = observer.events.last?.value.element else {
            XCTFail("movies is empty")
            return
        }
        XCTAssert((movies[0].title == "Deadpool 2") && (movies[0].rating == "★ 8.0"))
        XCTAssert((movies[1].title == "Red Sparrow") && (movies[1].rating == "★ 6.4"))
        XCTAssert((movies[2].title == "Jurassic World: Fallen Kingdom") && (movies[2].rating == "★ 0.0"))
        XCTAssert((movies[3].title == "A Quiet Place") && (movies[3].rating == "★ 5.9"))

        self.log(message: "[END]")
    }
}

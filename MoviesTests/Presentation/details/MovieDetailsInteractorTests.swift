//
//  MovieDetailsInteractorTests.swift
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

class MovieDetailsInteractorTests: XCTestCase {

    private var _disposeBag: DisposeBag!
    private var _scheduler: TestScheduler!
    private var _interactor: MovieDetailsInteractorProtocol!

    override func setUp() {
        super.setUp()

        _disposeBag = DisposeBag()
        _scheduler = TestScheduler(initialClock: 0)
        let movie = Movie(id: 383498, title: "Deadpool 2", posterPath: nil, backdropPath: nil, releaseDate: "2018-05-15", overview: "", rating: 8, genres: [Genre(id: 28, name: "Action")])
        _interactor = MovieDetailsInteractor(movie: movie)
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
    
    func test_movie() {
        self.log(message: "[START]")

        let observer = _scheduler.createObserver(Movie.self)
        _interactor.movie.drive(observer).disposed(by: _disposeBag)
        
        XCTAssert(!observer.events.isEmpty)
        observer.events.forEach { (event) in

            guard let movie = event.value.element else {
                XCTFail("movie is null")
                return
            }
            XCTAssert(movie.title == "Deadpool 2")
        }

        self.log(message: "[END]")
    }
}

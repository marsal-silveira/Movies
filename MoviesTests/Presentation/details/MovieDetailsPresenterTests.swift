//
//  MovieDetailsPresenter.swift
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

class MovieDetailsPresenterTests: XCTestCase {

    private var _disposeBag: DisposeBag!
    private var _scheduler: TestScheduler!

    private var _presenter: MovieDetailsPresenterProtocol!

    override func setUp() {
        super.setUp()

        _disposeBag = DisposeBag()
        _scheduler = TestScheduler(initialClock: 0)
        let movie = Movie(id: 383498, title: "Deadpool 2", posterPath: nil, backdropPath: nil, releaseDate: "2018-05-15", overview: "", rating: 8, genres: [Genre(id: 28, name: "Action")])
        _presenter = MovieDetailsPresenter(interactor: MovieDetailsInteractor(movie: movie))
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

        let observer = _scheduler.createObserver(MovieDetailsVO.self)
        _presenter.movie.drive(observer).disposed(by: _disposeBag)

        observer.events.forEach { (event) in
            
            guard let movie = event.value.element else {
                XCTFail("movie is null")
                return
            }
            XCTAssert((movie.title == "Deadpool 2") && (movie.rating == "★ 8.0"))
        }

        self.log(message: "[END]")
    }
}

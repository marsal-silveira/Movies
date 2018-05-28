//
//  MovieRepositoryTests.swift
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

class MovieRepositoryTests: XCTestCase {

    private var _disposeBag: DisposeBag!
    private var _scheduler: TestScheduler!
    private var _repository: MovieRepositoryProtocol!

    override func setUp() {
        super.setUp()

        _disposeBag = DisposeBag()
        _scheduler = TestScheduler(initialClock: 0)
        _repository = MovieRepository(tMDbAPI: TMDbAPIMock(), dao: MovieDaoMock(), genreRepository: GenreRepositoryMock())
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

        let observer = _scheduler.createObserver(RequestResponse<UpcomingMovies>.self)
        _repository.upcomingMovies.asDriver(onErrorJustReturn: .failure(MoviesError.error(description: "TODO:"))).drive(observer).disposed(by: _disposeBag)
        _repository.fetchUpcomingMovies(page: 1)

        observer.events.forEach { (event) in

            let response = event.value.element ?? .new
            switch response {
            case .success(let upcomingMovies):
                self.log(message: "upcomingMovies.movies >> \(upcomingMovies.movies.count)")
                XCTAssert(upcomingMovies.movies.count == 4)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            default:
                return
            }
        }

        self.log(message: "[END]")
    }
}

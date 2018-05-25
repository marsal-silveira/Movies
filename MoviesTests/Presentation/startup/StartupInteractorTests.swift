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
import RxTest

@testable import Movies

class StartupInteractorTests: XCTestCase {
    
    private var _disposeBag: DisposeBag!
    private var _scheduler: TestScheduler!
    private var _interactor: StartupInteractorProtocol!
    
    override func setUp() {
        super.setUp()
        print("setUp()")
        
        _disposeBag = DisposeBag()
        _scheduler = TestScheduler(initialClock: 0)
        _interactor = StartupInteractor(genreRepository: GenreRepositoryMock())
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown()")
        
        _disposeBag = nil
        _scheduler = nil
        _interactor = nil
    }

    func test_isDone_ok() throws {
        print(">>> test_isDone_ok")
        print(">>> [START]")
        
        let observable = _scheduler.createObserver(RequestResponse<Void>.self)
        _interactor.isDone.asDriver().drive(observable).disposed(by: _disposeBag)
        
        _interactor.fetchInitialData()
        
        XCTAssert(observable.events.contains { event in
            print("event -> \(event.value)")
            let response = event.value.element ?? .new
            switch response {
            case .success:
                return true
            default:
                return false
            }
        })
        print(">>> [END]")
    }
}

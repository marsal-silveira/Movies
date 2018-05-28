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
        
        _disposeBag = DisposeBag()
        _scheduler = TestScheduler(initialClock: 0)
        _interactor = StartupInteractor(genreRepository: GenreRepositoryMock())
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

    func test_isDone() {
        self.log(message: "[START]")
        
        let observer = _scheduler.createObserver(RequestResponse<Void>.self)
        _interactor.isDone.drive(observer).disposed(by: _disposeBag)
        
        _interactor.fetchInitialData()
        
        XCTAssert(observer.events.contains { event in
            let response = event.value.element ?? .new
            switch response {
            case .success:
                return true
            default:
                return false
            }
        })
        
        self.log(message: "[END]")
    }
}

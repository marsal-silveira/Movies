//
//  ErrorResultAPITests.swift
//  MoviesTests
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import XCTest
import ObjectMapper

@testable import Movies

class ErrorResultAPITests: XCTestCase {
    
    private func log(message: String) {
        print("\(String(describing: self)) >> \(message)")
    }
    
    func test_mapping() {
        self.log(message: "[START]")
        
        let error = Mapper<ErrorResultAPI>().map(JSON: JSONRepository.error)
        XCTAssert(error?.status == 404)
        XCTAssert(error?.message == "Not Found")
        
        self.log(message: "[END]")
    }
}

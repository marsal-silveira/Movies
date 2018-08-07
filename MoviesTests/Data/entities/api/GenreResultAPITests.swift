//
//  GenreResultAPITests.swift
//  MoviesTests
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import XCTest
import ObjectMapper

@testable import Movies

class GenreResultAPITests: XCTestCase {

    private func log(message: String) {
        print("\(String(describing: self)) >> \(message)")
    }

    func test_mapping() {
        self.log(message: "[START]")
        
        let genres = Mapper<GenreResultAPI>().mapArray(JSONArray: JSONRepository.genres)
        XCTAssert(genres.count == 19)
        XCTAssert(genres[0].name == "Action")
        XCTAssert(genres[18].name == "Western")
        
        self.log(message: "[END]")
    }
}

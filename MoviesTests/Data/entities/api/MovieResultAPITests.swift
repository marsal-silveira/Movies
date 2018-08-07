//
//  MovieResultAPITests.swift
//  MoviesTests
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import XCTest
import ObjectMapper

@testable import Movies

class MovieResultAPITests: XCTestCase {
    
    private func log(message: String) {
        print("\(String(describing: self)) >> \(message)")
    }
    
    func test_mapping() {
        self.log(message: "[START]")
        
        let movies = Mapper<MovieResultAPI>().mapArray(JSONArray: JSONRepository.movies)

        XCTAssert(movies.count == 4)
        XCTAssert(movies[0].title == "Jurassic World: Fallen Kingdom")
        XCTAssert(movies[3].title == "The Strangers: Prey at Night")
        
        self.log(message: "[END]")
    }
}

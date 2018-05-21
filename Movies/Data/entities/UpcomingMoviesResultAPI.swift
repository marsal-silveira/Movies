//
//  UpcomingMoviesResultAPI.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import ObjectMapper

class UpcomingMoviesResultAPI: Mappable {
    
    private(set) var page: Int?
    private(set) var totalPages: Int?
    private(set) var totalMovies: Int?
    private(set) var movies: [MovieResultAPI]?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        page <- map["page"]
        totalPages <- map["total_pages"]
        totalMovies <- map["total_results"]
        movies <- map["results"]
    }
}

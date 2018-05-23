//
//  MovieResultAPI.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieResultAPI: Mappable {
    
    private(set) var id: Int?
    private(set) var title: String?
    private(set) var posterPath: String?
    private(set) var backdropPath: String?
    private(set) var releaseDate: String?
    private(set) var overview: String?
    private(set) var genres: [Int]?
    private(set) var rating: Double?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        posterPath <- map["poster_path"]
        backdropPath <- map["backdrop_path"]
        releaseDate <- map["release_date"]
        overview <- map["overview"]
        genres <- map["genre_ids"]
        rating <- map["vote_average"]
    }
}

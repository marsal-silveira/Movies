//
//  Genre.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

struct Genre {
    
    private(set) var id: Int
    private(set) var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

// Decoder...
extension Genre {
    
    static func map(genreResult: GenreResultAPI) -> Genre? {
        
        guard let id = genreResult.id,
              let name = genreResult.name else {
            return nil
        }
        return Genre(id: id, name: name)
    }
    
    static func mapArray(genresResult: [GenreResultAPI]) -> [Genre] {
        
        return genresResult
            .map { map(genreResult: $0) }
            .filter { $0 != nil }
            .map { $0! }
    }
}

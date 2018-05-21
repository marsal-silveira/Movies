//
//  MoviesError.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

protocol MoviesErrorProtocol: LocalizedError, CustomStringConvertible {
    
}

extension MoviesErrorProtocol {
    
    var description: String {
        return errorDescription ?? ""
    }
}
    
enum MoviesError: MoviesErrorProtocol {

    case network
    case timeout
    case parsingJSON
    case error(description: String)

    var errorDescription: String? {

        switch self {
        case .network:
            return Strings.errorNetwork()
        case .timeout:
            return Strings.errorTimeout()
        case .parsingJSON:
            return Strings.errorParsingJson()
        case .error(let description):
            return description
        }
    }
}

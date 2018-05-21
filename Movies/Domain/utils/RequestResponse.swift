//
//  RequestResponse.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

enum RequestResponse<T> {
    case new
    case loading
    case success(T)
    case failure(Error)
    case cancelled
}

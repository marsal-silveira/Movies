//
//  ErrorResultAPI.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import ObjectMapper

// Store the error message and http status code returned from WebService when occurs error
struct ErrorResultAPI: Mappable {
    
    var status: Int?
    var message: String?
    
    var localizedDescription: String {
        return message ?? Strings.errorDefault()
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        status <- map["status_code"]
        message <- map ["status_message"]
    }
}

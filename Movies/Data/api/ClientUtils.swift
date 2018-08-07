//
//  ClientUtils.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import Moya
import Result
import RxSwift
import ObjectMapper

enum ClientUtils {
    
    private enum RxSwiftErrorCode {
        static let timeout: Int = 6
    }
    
    static func translateError(_ error: Swift.Error) -> Swift.Error {
        
        let extractedError = translateMoyaError(error)
        if extractedError.code == NSURLErrorNotConnectedToInternet || extractedError.code == NSURLErrorNetworkConnectionLost {
            return MoviesError.network
        }
        if extractedError.code == NSURLErrorTimedOut || extractedError.code == RxSwiftErrorCode.timeout {
            return MoviesError.timeout
        }
        return error
    }
    
    private static func translateMoyaError(_ error: Swift.Error) -> NSError {
        
        if let moyaError = error as? Moya.MoyaError {
            switch moyaError {
            case .underlying(let error, _):
                return error as NSError
            default:
                return moyaError as NSError
            }
        } else {
            return error as NSError
        }
    }
}

extension Data {
    
    var asJSON: Result<JSON, NSError> {
        do {
            guard let JSONDict = try JSONSerialization.jsonObject(with: self, options: []) as? JSON else {
                return Result.failure(MoviesError.parsingJSON as NSError)
            }
            return Result.success(JSONDict)
        } catch let error as NSError {
            return Result.failure(error)
        }
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    func processResponse() -> Single<Moya.Response> {
        
        return flatMap({ response -> Single<Moya.Response> in
            
            // process response code
            switch response.statusCode {
            case 200...299:
                return Single.just(response)
            default:
                
                switch response.data.asJSON {
                case .success(let JSONDict):
                    let errorDescription = Mapper<ErrorResultAPI>().map(JSON: JSONDict)?.localizedDescription ?? Strings.errorParsingJson()
                    return Single.error(MoviesError.error(description: errorDescription))
                case .failure(let error):
                    return Single.error(error)
                }
            }
        })
    }
}

//
//  MoviesAPI.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper
import Moya_ObjectMapper

extension TMDbAPI {
    
    enum Movies: TMDbTarget {
        case upcoming(page: Int)
        
        var path: String {
            switch self {
            case .upcoming(let page):
                return "/movie/upcoming?api_key=\(TMDbAPI.apiKey)&page=\(page)"
            }
        }
        
        static func getUpcoming(page: Int) -> Single<UpcomingMoviesResultAPI> {
            return self.provider.rx
                .request(Movies.upcoming(page: page))
                .timeout(TMDbAPI.Timeout.short, scheduler: MainScheduler.instance)
                .processResponse()
                .mapObject(UpcomingMoviesResultAPI.self)
                .catchError({ (error) -> Single<UpcomingMoviesResultAPI> in return Single.error(ClientUtils.translateError(error)) })
        }
    }
}

extension TMDbAPI.Movies {
    
    // TODO: I don't know why but I can't use a generic `provider` using Generic (e.g. MoyaProvider<T>) so I need create a new one for each Target... check if there is a better way to solve this :|
    static var provider = MoyaProvider<TMDbAPI.Movies>(
        endpointClosure: { (target) -> Endpoint<TMDbAPI.Movies> in return TMDbAPI.Movies.endpoint(target) },
        plugins: TMDbAPI.Movies.plugins
    )
}

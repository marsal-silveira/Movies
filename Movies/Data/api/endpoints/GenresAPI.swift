//
//  GenresAPI.swift
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
    
    enum Genres: TMDbTarget {
        case list
        
        var path: String {
            switch self {
            case .list:
                return "/genre/movie/list?api_key=\(TMDbAPI.apiKey)"
            }
        }
        
        static func getGenres() -> Single<[GenreResultAPI]> {

            return self.provider.rx
                .request(TMDbAPI.Genres.list)
                .timeout(TMDbAPI.Timeout.short, scheduler: MainScheduler.instance)
                .processResponse()
                .flatMap({ response -> Single<[GenreResultAPI]> in

                    // conver JSON to Genres array... we need do this manually because result (json) came enveloped into `genres`
                    guard let json = try response.mapJSON() as? JSON,
                          let genresJSON = json["genres"] as? [JSON] else {
                        throw MoyaError.jsonMapping(response)
                    }
                    let genres = Mapper<GenreResultAPI>(context: nil).mapArray(JSONArray: genresJSON)
                    return Single.just(genres)
                })
                .catchError({ (error) -> Single<[GenreResultAPI]> in return Single.error(ClientUtils.translateError(error)) })
        }
    }
}

extension TMDbAPI.Genres {
    
    // TODO: I don't know why but I can't use a generic `provider` using Generic (e.g. MoyaProvider<T>) so I need create a new one for each Target... check if there is a better way to solve this :|
    static var provider = MoyaProvider<TMDbAPI.Genres>(
        endpointClosure: { (target) -> Endpoint<TMDbAPI.Genres> in return TMDbAPI.Genres.endpoint(target) },
        plugins: TMDbAPI.Genres.plugins
    )
}

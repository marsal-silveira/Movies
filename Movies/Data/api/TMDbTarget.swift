//
//  TMDbTarget.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import Moya

//// This doesn't work and I don't know why :|
//class ClientAPI<T: TargetType> {
//
//    lazy var provider = MoyaProvider<T>(
//        endpointClosure: { (target) -> Endpoint<T> in
//            return Endpoint<T>(
//                url: "\(target.baseURL)\(target.path)",
//                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
//                method: target.method,
//                task: target.task,
//                httpHeaderFields: target.headers
//            )
//        },
//        plugins: [
//            NetworkActivityPlugin { (change, _) in UIApplication.shared.isNetworkActivityIndicatorVisible = change == .began },
//            NetworkLoggerPlugin(verbose: true)
//        ]
//    )
//}

protocol TMDbTarget: TargetType {
    // Use these to shared provider and endpoint behavior between all Targets
    static var provider: MoyaProvider<Self> { get }
    static var plugins: [PluginType] { get }
    static func endpoint(_ target: Self) -> Endpoint<Self>
}

extension TMDbTarget {

    var baseURL: URL {
        return URL(string: TMDbAPI.apiBasePath)!
    }

    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var parameters: JSON? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
}

// ************************************************
// MARK: - Provider Default values...
// ************************************************

extension TMDbTarget {

    static func endpoint(_ target: Self) -> Endpoint<Self> {
        return Endpoint<Self>(
            url: "\(target.baseURL)\(target.path)",
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }
    
    static var plugins: [PluginType] {
        return [
            NetworkActivityPlugin { (change, _) in UIApplication.shared.isNetworkActivityIndicatorVisible = change == .began }
            // for debug purpose
            ,NetworkLoggerPlugin(verbose: true)
        ]
    }
}

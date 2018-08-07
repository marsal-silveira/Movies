//
//  NetworkManager.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

class NetworkManager {

    //*************************************************
    // MARK: - Singleton | Init
    //*************************************************

    static let shared = NetworkManager()
    
    init() {
        let status: NetworkReachabilityManager.NetworkReachabilityStatus = (_reachabilityManager?.isReachable ?? false) ? .reachable(.ethernetOrWiFi) : .notReachable
        _reachabilityStatus = Variable<NetworkReachabilityManager.NetworkReachabilityStatus>(status)
    }

    // *************************************************
    // MARK: - Reachability
    // *************************************************
    
    private let _reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")

    private var _reachabilityStatus: Variable<NetworkReachabilityManager.NetworkReachabilityStatus>
    var reachabilityStatus: Observable<NetworkReachabilityManager.NetworkReachabilityStatus> { return _reachabilityStatus.asObservable() }
    
    var isReachable: Bool { return (_reachabilityStatus.value != .notReachable) && (_reachabilityStatus.value != .unknown) }

    func startNetworkReachabilityObserver() {
        
        _reachabilityManager?.listener = { [weak self] (status) in
            self?._reachabilityStatus.value = status
            
            // debug
            switch status {
            case .notReachable:
                print("[Reachability] The network is not reachable")
            case .unknown :
                print("[Reachability] It is unknown whether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                print("[Reachability] The network is reachable over the WiFi connection")
            case .reachable(.wwan):
                print("[Reachability] The network is reachable over the WWAN connection")
            }
        }
        
        // start listening
        _reachabilityManager?.startListening()
    }
}

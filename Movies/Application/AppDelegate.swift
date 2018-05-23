//
//  AppDelegate.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Singleton
    static let shared: AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    var appName: String {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let name = infoDictionary[kCFBundleNameKey as String] as? String else {
            return "Movies"
        }
        return name
    }
    
    var window: UIWindow?

    var container: Container? {
        return window?.rootViewController as? Container
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // start network reachability listening...
        NetworkManager.shared.startNetworkReachabilityObserver()

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        Container.present(on: window)

        return true
    }
}

// ***********************************************
// MARK: - Directories
// ***********************************************

extension AppDelegate {

    var rootDirectory: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }

    func rootDirectory(appending filename: String) -> URL {
        return self.rootDirectory.appendingPathComponent(filename)
    }

    var rootDirectoryPath: String {
        return self.rootDirectory.path
    }

    func rootDirectoryPath(appending filename: String) -> String {
        return self.rootDirectory(appending: filename).path
    }
    
    var databaseDirectory: URL {
        
        let databaseDirectory = AppDelegate.shared.rootDirectory(appending: "database")
        let databaseDirectoryPath = databaseDirectory.path
        if !FileManager.default.fileExists(atPath: databaseDirectoryPath) {
            
            do {
                try FileManager.default.createDirectory(at: databaseDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating '\(databaseDirectoryPath)' Directory.")
            }
        }
        return databaseDirectory
    }
}

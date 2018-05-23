//
//  BaseRouter.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit

class BaseRouter: NSObject {
    
    // used to retain the presented router references... without this the presented router will be released from memory
    var presentedRouter: BaseRouter?

    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}

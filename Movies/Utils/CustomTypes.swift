//
//  CustomTypes.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

//*************************************************
// MARK: - Wrapper
//*************************************************

typealias JSON = [String : Any]
typealias VoidClosure = () -> ()

//*************************************************
// MARK: - Operators
//*************************************************

prefix operator ❗️
prefix func ❗️(a: Bool) -> Bool { return !a }

// *************************************************
// MARK: - Resources (Wrapper to R.swift)
// *************************************************

typealias Strings = R.string.localizable
typealias Images = R.image
typealias Nibs = R.nib

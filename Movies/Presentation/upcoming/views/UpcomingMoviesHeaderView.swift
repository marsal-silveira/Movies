//
//  UpcomingMoviesHeaderView.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class UpcomingMoviesHeaderView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyLayout()
    }
    
    private func applyLayout() {
        titleLabel.text = Strings.upcomingMoviesTitle()
        titleLabel.textColor = .white
    }
}

extension UpcomingMoviesHeaderView {
    
    static func loadNibName() -> UpcomingMoviesHeaderView {
        return Nibs.upcomingMoviesHeaderView().instantiate(withOwner: nil).first! as! UpcomingMoviesHeaderView
    }
}

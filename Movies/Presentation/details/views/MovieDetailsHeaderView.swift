//
//  MovieDetailsHeaderView.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import RxSwift
import RxCocoa
import Kingfisher

class MovieDetailsHeaderView: NibDesignable {
    
    // ************************************************
    // MARK: @IBOutlets
    // ************************************************

    @IBOutlet fileprivate weak var loadignIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var backdropImage: UIImageView!

    //*************************************************
    // MARK: - Load Image
    //*************************************************
    
    func loadMovieBackdrop(_ backdropPath: String?) {

        if let picturePath = backdropPath, let pictureURL = URL(string: picturePath) {
            ImageDownloader.default.downloadImage(with: pictureURL, completionHandler: { [weak self] (image, error, _, _) in
                self?.updateBackdropImage(image ?? #imageLiteral(resourceName: "img_placeholder"))
            })
        } else {
            self.updateBackdropImage(#imageLiteral(resourceName: "img_placeholder"))
        }
    }

    private func updateBackdropImage(_ image: UIImage) {

        self.loadignIndicator.stopAnimating()
        self.loadignIndicator.isHidden = true
        self.backdropImage.image = image
    }
}

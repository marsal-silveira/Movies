//
//  MovieCell.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var loadignIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var posterImageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var genresLabel: UILabel!
    @IBOutlet fileprivate weak var releaseDateLabel: UILabel!
    @IBOutlet fileprivate weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.posterImageView.image = #imageLiteral(resourceName: "img_placeholder")
        self.loadignIndicator.isHidden = false
        self.loadignIndicator.startAnimating()
    }
    
    private func updatePosterImage(_ image: UIImage) {
        
        self.loadignIndicator.stopAnimating()
        self.loadignIndicator.isHidden = true
        self.posterImageView.image = image
    }
    
    private func downloadPoster(movie: UpcomingMovieVO) {
        
        if let picturePath = movie.posterPath, let pictureURL = URL(string: picturePath) {
            
            ImageDownloader.default.downloadImage(
                with: pictureURL,
                completionHandler: { [weak self] (image, error, _, _) in
                    self?.updatePosterImage(image ?? #imageLiteral(resourceName: "img_placeholder"))
                }
            )
        } else {
            self.updatePosterImage(#imageLiteral(resourceName: "img_placeholder"))
        }
    }
    
    func setup(movie: UpcomingMovieVO) {
        
        DispatchQueue.main.async { [weak self] in
        
            self?.titleLabel.text = movie.title
            self?.genresLabel.text = movie.genres
            self?.releaseDateLabel.text = movie.releaseDate
            self?.ratingLabel.text = movie.rating
            
            self?.downloadPoster(movie: movie)
        }
    }
}

//
//  MovieDetailsViewController.swift
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

class MovieDetailsViewController: BaseViewController {
    
    // ************************************************
    // MARK: @IBOutlets
    // ************************************************
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var ratingLabel: UILabel!
    @IBOutlet fileprivate weak var ratingValueLabel: UILabel!
    @IBOutlet fileprivate weak var releaseDateLabel: UILabel!
    @IBOutlet fileprivate weak var releaseDateValueLabel: UILabel!
    @IBOutlet fileprivate weak var genreLabel: UILabel!
    @IBOutlet fileprivate weak var genreValueLabel: UILabel!
    @IBOutlet fileprivate weak var overviewLabel: UILabel!
    
    // ************************************************
    // MARK: Properties
    // ************************************************
    
    override class var NibName: String? {
        return Nibs.movieDetailsViewController.name
    }

    private var _presenter: MovieDetailsPresenterProtocol {
        return basePresenter as! MovieDetailsPresenterProtocol
    }

    fileprivate var _disposeBag = DisposeBag()
    
    // ************************************************
    // MARK: UI Components
    // ************************************************
    
    private lazy var _header: MovieDetailsHeaderView = {
        return MovieDetailsHeaderView()
    }()

    // ************************************************
    // MARK: Setup
    // ************************************************
    
    override func bind() {
        super.bind()

        _presenter.movie
            .drive(onNext: { [weak self] (movie) in
                self?.loadData(movie)
            })
            .disposed(by: _disposeBag)
    }
    
    override internal func applyLayout() {
        super.applyLayout()

        self.addHeader()
        ratingLabel.text = Strings.movieDetailsRating()
        releaseDateLabel.text = Strings.movieDetailsReleaseDate()
        genreLabel.text = Strings.movieDetailsGenre()
    }
    
    private func addHeader() {
        scrollView.parallaxHeader.view = _header
        scrollView.parallaxHeader.height = 230
        scrollView.parallaxHeader.minimumHeight = 0
        scrollView.parallaxHeader.mode = .centerFill
    }

    //*************************************************
    // MARK: - Data
    //*************************************************
    
    private func loadData(_ movie: MovieDetailsVO) {

        titleLabel.text = movie.title
        ratingValueLabel.text = movie.rating
        releaseDateValueLabel.text = movie.releaseDate
        genreValueLabel.text = movie.genre
        overviewLabel.text = movie.overview
        
        _header.loadMovieBackdrop(movie.backdropPath)
    }
}

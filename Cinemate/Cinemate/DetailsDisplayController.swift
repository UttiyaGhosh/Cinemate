//
//  DetailsDisplayController.swift
//  Cinemate
//
//  Created by user235924 on 12/8/23.
//

import UIKit

class DetailsDisplayController: UIViewController,NetworkingDelegate {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    
    var movieId: Int?
    
    override func viewDidLoad() {
        //URL Source: https://developer.themoviedb.org/reference/movie-details

        super.viewDidLoad()
        NetworkingManager.shared.delegate = self
        NetworkingManager.shared.getMovieDetails(movieId: movieId!)
        
        self.titleLabel.text = ""
        self.languageLabel.text = ""
        self.releaseDateLabel.text = ""
        self.voteLabel.text = ""
    }

    func networkingDidFinishWithMovies(movieSearchDetails: [MovieSearchDetail]) {
        
    }
    
    
    func networkingDidFinishWithMovieDetails(movieDetail: MovieDetail) {
        if let posterPath = movieDetail.poster_path {
            let url = "https://image.tmdb.org/t/p/w500\(posterPath)"
            
            // Using a background queue to download image
            let queue = DispatchQueue(label: "myq")
            queue.async {
                if let imageUrl = URL(string: url),
                   let data = try? Data(contentsOf: imageUrl),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = image
                    }
                }
            }
        } else {
            self.posterImageView.image = UIImage(named: "imageNotFound")
        }
        
        DispatchQueue.main.async {
            self.titleLabel.text = movieDetail.original_title
            self.languageLabel.text = movieDetail.original_language
            self.releaseDateLabel.text = movieDetail.release_date
            self.voteLabel.text = String(movieDetail.vote_average)
        }
    }
    
    func networkingDidFinishWithError() {
        
    }

}

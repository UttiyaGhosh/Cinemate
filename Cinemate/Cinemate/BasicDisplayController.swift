//
//  BasicDisplayController.swift
//  Cinemate
//
//  Created by user235924 on 12/8/23.
//

import UIKit

class BasicDisplayController: UIViewController{
    
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movieDetailFromSVC: MovieSearchDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleBar.title = movieDetailFromSVC?.title
        
        overviewLabel.text = movieDetailFromSVC?.overview
        overviewLabel.lineBreakMode = .byWordWrapping
            overviewLabel.numberOfLines = 0

        if let backdropPath = movieDetailFromSVC?.backdrop_path {
            let url = "https://image.tmdb.org/t/p/w500\(backdropPath)"
            
            // Using a background queue to download image
            let queue = DispatchQueue(label: "myq")
            queue.async {
                if let imageUrl = URL(string: url),
                   let data = try? Data(contentsOf: imageUrl),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.backdropImageView.image = image
                    }
                }
            }
        } else {
            self.backdropImageView.image = UIImage(named: "imageNotFound")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       var ddc = segue.destination as! DetailsDisplayController

        ddc.movieId = movieDetailFromSVC?.id
    }
}

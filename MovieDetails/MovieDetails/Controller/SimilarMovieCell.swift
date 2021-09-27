//
//  SimilarMovieCell.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 24/09/21.
//

import UIKit

class SimilarMovieCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
  //MARK: - Set Movie Poster Image
    func setImage(from url: String) {
        //Get the imageURL
        guard let imageURL = URL(string: url) else { return }

        //Uses DispatchQueue to not freeze the UI
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            let image = UIImage(data: imageData)
            //Set the image to the ImageView
            DispatchQueue.main.async {
                self.moviePosterImage.image = image
            }
        }
    }
    
}

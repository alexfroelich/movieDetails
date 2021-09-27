//
//  SimilarMovies.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 24/09/21.
//

import Foundation
import UIKit

struct SimilarMovie{
    let genres: [Int]
    let id: Int
    let originalTitle: String
    let posterPath: String
    let releaseDate: String
    var posterImage: UIImage?
    
    mutating func getImage(from url: String){
        guard let imageURL = URL(string: url) else { print("error")
            return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        let image = UIImage(data: imageData)
        self.posterImage = image
        
    }
}

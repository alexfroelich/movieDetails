//
//  SimilarMoviesManager.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 24/09/21.
//

import Foundation
import UIKit

protocol SimilarMoviesDelegate{
    func didGetSimilarMovies(_ similarMoviesManager: SimilarMoviesManager, similarMovies: [SimilarMovie])
    func didFailWithError(error: Error)
    
}
struct SimilarMoviesManager {
    
    let url = "https://api.themoviedb.org/3/movie/27205/similar?api_key=3747b7bcad924a9dce4ed448e17d1055"
    var imageURL = "https://image.tmdb.org/t/p/w500"
    
    var delegate: SimilarMoviesDelegate?
    
    func getSimilarMovies(completion: @escaping (String?, Error?) -> ())  {
        //Create URL
        if let url = URL(string: self.url){
            //Create Session
            let session = URLSession(configuration: .default)
            //Create the task
            let task = session.dataTask(with: url){data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                //Safe Data
                if let safeData = data {
                    if let similarMovies = self.parseJSON(similarMovieData: safeData){
                        delegate?.didGetSimilarMovies(self, similarMovies: similarMovies)
                    }
                }
            }
            //Start the task
            task.resume()
        }
        completion("ok", nil)
    }
    
    func parseJSON(similarMovieData: Data) -> [SimilarMovie]? {
        let decoder = JSONDecoder()
        
        do{
            //Getting the data
            let decodedData = try decoder.decode(Results.self, from: similarMovieData)
            //Create an array of Similar Movies
            var movies = [SimilarMovie]()
            
            //Iterate each movie from decoded data
            for movie in decodedData.results{
                //Get the desired data
                let path = imageURL + movie.poster_path
                let posterImage = getImage(from: path) ?? nil
                
                //Create a similar movie
                let similarMovie = SimilarMovie(genres: movie.genre_ids, id: movie.id, originalTitle: movie.original_title, posterPath: imageURL + movie.poster_path, releaseDate: movie.release_date, posterImage: posterImage)
                
                //Add the similarMovie to the array
                movies.append(similarMovie)
                
                //Limit to only a part of the total
                if movies.count >= 10{
                    break
                }
            }
            
            return movies
            
        }catch{
            //Error
            delegate?.didFailWithError(error: error)
            return nil
        }
    } 
   
    //MARK: - Get Image From URL
    func getImage(from url: String) -> UIImage?{
        //Gets the image from a given URL
        guard let imageURL = URL(string: url) else { return nil }
        guard let imageData = try? Data(contentsOf: imageURL) else { return nil }
        let image = UIImage(data: imageData)
        return image
        
    }
    
}

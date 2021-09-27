//
//  MovieManager.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 23/09/21.
//

import Foundation

protocol MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager ,movie: Movie)
    func didFailWithError(error: Error)
}

struct MovieManager{
    
    let url = "https://api.themoviedb.org/3/movie/27205?api_key=3747b7bcad924a9dce4ed448e17d1055"
    var imageURL = "https://image.tmdb.org/t/p/w500"
    
    var delegate: MovieManagerDelegate?
    
    func performRequest(completion: @escaping (String?, Error?) -> ()) {
        //1. Create a URL
        if let url = URL(string: url){
            //Create a URLSession
            let session = URLSession(configuration: .default)
            //Give the session a task
            let task = session.dataTask(with: url){data, response, error in
                if error != nil{
                    
                    delegate?.didFailWithError(error: error!)
                    return
                }
                //Safe Data
                if let safeData = data{
                    if let movie = self.parseJSON(movieData: safeData){
                        delegate?.didUpdateMovie(self, movie: movie)
                    }
                }
            }
            //Start the task
            task.resume()
        }
        completion("ok", nil)
    }
    
    func  parseJSON(movieData: Data) -> Movie? {
        let decoder = JSONDecoder()
        do{
            //Fetch the data
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            let id = decodedData.id
            let title = decodedData.original_title
            let posterPath = imageURL + decodedData.poster_path
            let popularity = decodedData.popularity
            let voteCount = decodedData.vote_count
            //Create a movie with the fetched data
            let movie = Movie(title: title, id: id, posterPath: posterPath, voteCount: voteCount, popularity: popularity)
            
            return movie
            
        }catch{
            //Error
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
   
    
}

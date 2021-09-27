//
//  GenresManager.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 26/09/21.
//

import Foundation

protocol GenresDelegate {
    func didGetGenres(_ genresManager: GenresListManager, genres: [Genre])
    func didFailWithError(error: Error)
}
struct GenresListManager{
    
    let url = "https://api.themoviedb.org/3/genre/movie/list?api_key=3747b7bcad924a9dce4ed448e17d1055"
   
    var delegate: GenresDelegate?
   
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
                    if let genres = self.parseJSON(genresData: safeData){
                        delegate?.didGetGenres(self, genres: genres)
                       
                    }
                    
                }
            }
            //Start the task
            task.resume()
        }
        completion("ok", nil)
    }
    
    func  parseJSON(genresData: Data) -> [Genre]? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(GenresListData.self, from: genresData)
            //Get the array of genres
            let genres = decodedData.genres
            
            //Create an array to store the genres
            var genresList = [Genre]()
            
            //Iterate the decoded data
            for genre in genres{
                //Create a genre and add it to the array
                let genreItem = Genre(id: genre.id, name: genre.name)
                genresList.append(genreItem)
                
            }
            
            return genresList
        }catch{
            
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

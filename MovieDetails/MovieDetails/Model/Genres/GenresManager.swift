//
//  GenresManager.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 26/09/21.
//

import Foundation

struct GenresListManager{
    
    let url = "https://api.themoviedb.org/3/genre/movie/list?api_key=3747b7bcad924a9dce4ed448e17d1055"
   //To Do: Delegate
    func performRequest(completion: @escaping (String?, Error?) -> ()) {
        //1. Create a URL
        if let url = URL(string: url){
            //Create a URLSession
            let session = URLSession(configuration: .default)
            //Give the session a task
            let task = session.dataTask(with: url){data, response, error in
                if error != nil{
                    print(error!)
                    //To Do: Delegate
                    //delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let genres = self.parseJSON(genresData: safeData){
                    
                        //To Do: Delegate
                        //delegate?.didUpdateMovie(self, movie: movie)
                    }
                    //let dataString = String(data: safeData, encoding: .utf8)
                    //print(dataString!)
                }
            }
            //Start the task
            task.resume()
        }
        completion("ok", nil)
    }
    
    func  parseJSON(genresData: Data) -> GenresList? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(GenresData.self, from: genresData)
            //let id = decodedData.id
            print(decodedData)
            
            return nil
        }catch{
            print(error)
            //To Do: Delegate
            //delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

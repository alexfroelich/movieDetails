//
//  Genres.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 26/09/21.
//

import Foundation

struct GenresList {
    var genreList: [Int: String] = [:]
    
    init() {
        
    }
    
    init(list: [Genre]) {
        for genre in list{
            
            genreList[genre.id] = genre.name
            
        }
    }
    
    func getGenre(genreIndex: Int) -> String? {
        return genreList[genreIndex]
    }
}
struct Genre: Decodable {
    var id: Int
    var name: String
    
}

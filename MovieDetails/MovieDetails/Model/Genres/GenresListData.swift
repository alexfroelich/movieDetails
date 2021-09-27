//
//  GenresData.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 26/09/21.
//

import Foundation

struct GenresListData: Decodable {
    let genres: [GenreData]
}

struct GenreData: Decodable{
    let id: Int
    let name: String
}

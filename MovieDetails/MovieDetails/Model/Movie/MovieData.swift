//
//  MovieData.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 23/09/21.
//

import Foundation

struct MovieData: Decodable{
    let id: Int
    let original_title: String
    let poster_path: String
    let vote_count: Int
    let popularity: Double
}

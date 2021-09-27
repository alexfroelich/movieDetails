//
//  SimilarMoviesData.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 24/09/21.
//

import Foundation

struct SimilarMoviesData: Decodable{
    var genre_ids: [Int]
    var id: Int
    var original_title: String
    var poster_path: String
    var release_date: String
}


struct Results: Decodable {
    var page: Int
    var results: [SimilarMoviesData]
}

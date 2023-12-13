//
//  Movie.swift
//  Cinemate
//
//  Created by user235924 on 12/4/23.
//

import Foundation

class MovieSearchResult: Codable {
    let results: [MovieSearchDetail]
    let page: Int
    let total_pages: Int
    let total_results: Int
}
class MovieSearchDetail: Codable {
    let id: Int
    let overview: String
    let backdrop_path: String?
    let title: String
}

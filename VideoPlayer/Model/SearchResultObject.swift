//
//  SearchModel.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/18.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation

struct SearchResultObject: Codable {
    var page: Int!
    var total_results: Int!
    var total_pages: Int!
    var results: [Result]!
    
}

struct Result: Codable {
    var original_name: String!
    var id: Int!
    var media_type: String!
    var name: String!
    var popularity: Float!
    var vote_count: Float!
    var vote_average: Float!
    var first_air_date: String!
    var poster_path: String!
    var genre_ids: [Int]!
    var original_language: String!
    var backdrop_path: String!
    var overview: String!
    var origin_country: [String]!
    
}

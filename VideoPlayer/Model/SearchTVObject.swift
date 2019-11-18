//
//  SearchTVObject.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/18.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation

struct SearchTVObject: Codable {
    var air_date: String!
    var crew: [Crew]!
    var episode_number: Int!
    var guest_stars: [GuestStar]!
    var name: String!
    var overview: String!
    var id: Int!
    var production_code: String!
    var season_number: Int!
    var still_path: String!
    var vote_average: Float!
    var vote_count: Int!
}


struct Crew: Codable {
    var id: Int!
    var credit_id: String!
    var name: String!
    var department: String!
    var job: String!
    var gender: Int!
    var profile_path: String!
}

struct GuestStar: Codable {
    var id: Int!
    var credit_id: String!
    var name: String!
    var character: String!
    var order: Int!
    var gender: Int!
    var profile_path: String!
}

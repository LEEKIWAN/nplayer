//
//  SearchTVObject.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/18.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation

struct SearchTVEpisodeObject: Codable {
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
    
    func getCrewText(job: String) -> String{
        var crewText = ""
        for i in 0 ..< crew.count {
            if crew[i].job == job {
                crewText.append("\(crew[i].name ?? ""), ")
            }
        }
        crewText = String(crewText.dropLast(2))
        
        return crewText
    }
    
    func getGuestText() -> String{
        var guestText = ""
        for i in 0 ..< guest_stars.count {
            guestText.append("\(guest_stars[i].name ?? ""), ")
        }
        guestText = String(guestText.dropLast(2))
        
        return guestText
    }
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

//-=---------------------------------------
struct SearchTVObject: Codable {
    var backdrop_path: String!
    var created_by: [CreatedBy]!
    var episode_run_time: [Int]!
    var first_air_date: String!
    var genres: [Genres]!
    var homepage: String!
    var id: Int!
    var in_production: Bool!
    var languages: [String]!
    var last_air_date: String!
    var last_episode_to_air: LastEpisodeToAir!
    var next_episode_to_air: String!
    var networks: [Network]!
    var number_of_episodes: Int!
    var number_of_seasons: Int!
    var origin_country: [String]!
    var original_language: String!
    var original_name: String!
    var overview: String!
    var popularity: Float!
    var poster_path: String!
    var production_companies: [ProductionCompany]!
    var seasons: [Season]!
    var status: String!
    var type: String!
    var vote_average: Float!
    var vote_count: Int!
    
    
    func getGenreText() -> String {
        var genreText = ""
        for i in 0 ..< genres.count {
            genreText.append("\(genres[i].name ?? ""), ")
        }
        
        genreText = String(genreText.dropLast(2))
        return genreText
    }
    
    
}

struct CreatedBy: Codable {
    var id: Int!
    var credit_id: String!
    var name: String!
    var gender: Int!
    var profile_path: String!
}

struct Genres: Codable {
    var id: Int!
    var name: String!
}


struct LastEpisodeToAir: Codable {
    var air_date: String!
    var episode_number: Int!
    var id: Int!
    var name: String!
    var production_code: String!
    var season_number: Int!
    var show_id: Int!
    var still_path: String!
    var vote_average: Int!
    var vote_count: Int!
}


struct Network: Codable {
    var id: Int!
    var name: String!
    var origin_country: String!
    var logo_path: String!
}


struct ProductionCompany: Codable {
    var id: Int!
    var name: String!
    var origin_country: String!
    var logo_path: String!
}


struct Season: Codable {
    var id: Int!
    var name: String!
    var air_date: String!
    var episode_count: Int!
    var overview: String!
    var poster_path: String!
    var season_number: Int!
}

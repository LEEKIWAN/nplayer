//
//  TheMovieDB.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/15.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation
import Alamofire


class TheMovieDB {
    static let shared = TheMovieDB()
    
    let api_key = "65657e31c98d6c9bdd3633d8c482d8fa"
    let serverURL = "https://api.themoviedb.org/3/"
    let language = "ko-KR"
    let searchQuery = "search/multi"
    //    var movieQuery = "search/multi"
    //    var tvQuery = "tv/{tv_id}/season/{season_number}/episode/{episode_number}"
    
    var title: [String] = []
    var season: [String] = []
    var episode: [String] = []
    
    
    func initMemberVariable(fileName: String) {
        title.removeAll()
        season.removeAll()
        episode.removeAll()
        
        season = fileName.season()
        episode = fileName.episode()
        title = fileName.title()
    }
    
    func requestDB(completion: @escaping (Bool, Any) -> Void) {

        guard let requestURL = URL(string: "\(serverURL)\(searchQuery)"), title.count > 0 else { return }
        print(requestURL)
        let parameters = ["query" : title.first!, "language" : language, "api_key" : api_key]
        
        AF.request(requestURL, method: .get, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let result):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                    
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(SearchResultObject.self, from: jsonData)
                    
                    if data.results.count > 0 {
                        if data.results.first!.media_type == "tv" {
                            self.requestTVDB(id: data.results.first!.id, completion: completion)
                        }
                            
                        else {
                            
                        }
                    }
                    
                    
                }
                catch {
                    print(error.localizedDescription)
                    completion(false, error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.errorDescription!)
                completion(false, error.localizedDescription)
            }
            
        }
    }
    
    func requestTVDB(id: Int, completion: @escaping (Bool, Any) -> Void){
        let tvID = id
        let parameters = ["query" : title.first!, "language" : language, "api_key" : api_key]
        var requestParametsers = "tv/\(tvID)"
        
        if self.season.count > 0 {
            requestParametsers.append("/season/\(self.season.first!.dropFirst() )")
        }
        
        if self.episode.count > 0 {
            requestParametsers.append("/episode/\(self.episode.first!.dropFirst())")
        }
        
        guard let tvRequestURL = URL(string: "\(self.serverURL)\(requestParametsers)") else { return }
        
        print(tvRequestURL)
        AF.request(tvRequestURL, method: .get, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let result):
                print(result)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(SearchTVObject.self, from: jsonData)
                    
                    completion(true, data)
                }
                catch {
                    print(error.localizedDescription)
                    completion(false, error.localizedDescription)
                }
                
                
            case .failure(let error):
                print(error.errorDescription!)
                completion(false, error.localizedDescription)
            }
        }
    }
    
    
    
    
}

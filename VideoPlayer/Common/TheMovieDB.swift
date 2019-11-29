//
//  TheMovieDB.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/15.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation
import Alamofire

enum MediaType {
    case tv
    case movie
    case none
}

class TheMovieDB {
    static let shared = TheMovieDB()
    
    var imageServerURL = "https://image.tmdb.org/t/p/original/"
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
    
    func requestDB(fileName: String, completion: @escaping (Bool, SearchResultObject?) -> Void) {
        self.initMemberVariable(fileName: fileName)
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
                    
                    completion(true, data)
                    
                }
                catch {
                    print(error.localizedDescription)
                    completion(false, nil)
                }
                
            case .failure(let error):
                print(error.errorDescription!)
                completion(false, nil)
            }
            
        }
    }
    
    func requestTVEpisodeDB(id: Int, completion: @escaping (Bool, SearchTVEpisodeObject?) -> Void){
        
        let tvID = id
        let parameters = ["query" : title.first!, "language" : language, "api_key" : api_key]
        var requestParametsers = "tv/\(tvID)"
        
        if self.season.count > 0 {
            requestParametsers.append("/season/\(self.season.first!.dropFirst() )")
        }
        else {
            requestParametsers.append("/season/1")
        }
        
        if self.episode.count > 0 {
            requestParametsers.append("/episode/\(self.episode.first!.dropFirst())")
        }
        else {
            requestParametsers.append("/episode/1")
        }
        
        guard let tvRequestURL = URL(string: "\(self.serverURL)\(requestParametsers)") else { return }

        AF.request(tvRequestURL, method: .get, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let result):
                print(result)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(SearchTVEpisodeObject.self, from: jsonData)
                    
                    completion(true, data)
                }
                catch {
                    print(error.localizedDescription)
                    completion(false, nil)
                }
                
                
            case .failure(let error):
                print(error.errorDescription!)
                completion(false, nil)
            }
        }
    }
    
    func requestTVDB(id: Int, completion: @escaping (Bool, SearchTVObject?) -> Void){
        let tvID = id
        let parameters = ["query" : title.first!, "language" : language, "api_key" : api_key]
        let requestParametsers = "tv/\(tvID)"
        
        guard let tvRequestURL = URL(string: "\(self.serverURL)\(requestParametsers)") else { return }
        
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
                    completion(false, nil)
                }
                
                
            case .failure(let error):
                print(error.errorDescription!)
                completion(false, nil)
            }
        }
    }
    
    func requestImageTVDB(path: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: "\(self.imageServerURL)\(path)") else { return }
        AF.request(url).responseData { (response) in
            switch response.result {
            case .success(let result):
                let image = UIImage(data: result)
                completion(image)
            case .failure(let error):
                print(error.errorDescription ?? "")
                completion(nil)
            }
        }
    }
    
    
}

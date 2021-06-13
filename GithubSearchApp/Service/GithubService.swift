//
//  GithubService.swift
//  GithubSearchApp
//
//  Created by Leo on 2021/06/12.
//

import Foundation

class GithubService: NSObject {
    
    private let perPage = 15
    private let apiHostURL = URL(string: "https://api.github.com")!
    
    func searchRepos(keyword:String,page:Int, completion : @escaping (Repo) -> ()){
     
        guard keyword != "" else {
            return
        }
        
        let urlstring = "\(apiHostURL.absoluteString)/search/repositories?q=\(keyword)&per_page=\(perPage)&page=\(page)"
        
        print(urlstring)
        
        URLSession.shared.dataTask(with: URL(string: urlstring)!){ (data, urlResponse, error) in
            
            if error == nil {
                    do {
                        if let data = data {
                            let jsonDecoder = JSONDecoder()
                            let usersData = try jsonDecoder.decode(Repo.self, from: data)
                            completion(usersData)
                        }
                    }
                    catch {
                        print(error)
                    }
                }
            
            
            
        }.resume()
    }
}


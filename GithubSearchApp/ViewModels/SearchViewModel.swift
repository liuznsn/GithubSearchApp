//
//  SearchViewModel.swift
//  GithubSearchApp
//
//  Created by Leo on 2021/06/12.
//

import Foundation

class SearchViewModel: NSObject {
    
    private var githubService : GithubService!
    private var page : Int = 1
    private var keyword : String = ""
    private (set) var items : [Item]! {
        didSet{
            self.bindUsersViewModel()
        }
    }
    
    var bindUsersViewModel : (() -> ()) = {}
    
    func getSearchRepo(keyword: String,completion : @escaping () -> ()) {
        self.githubService.searchRepos(keyword: keyword, page: page) { repo in
            self.keyword = keyword
            self.items = repo.items
            completion()
        }
    }
    
    func nextPageSearchRepos(completion : @escaping () -> ()) {
        page = page + 1
        self.githubService.searchRepos(keyword: self.keyword, page: page) { repo in
            self.items.append(contentsOf: repo.items)
            completion()
        }
    }
    
    override init() {
        super.init()
        self.githubService = GithubService()
    }
}

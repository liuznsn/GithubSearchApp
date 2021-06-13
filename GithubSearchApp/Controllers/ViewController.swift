//
//  ViewController.swift
//  GithubSearchApp
//
//  Created by Leo on 2021/06/12.
//

import UIKit

class ViewController: UIViewController {

    var searchTableView: UITableView!
    
    private var searchViewModel : SearchViewModel!
    private var dataSource : SearchTableViewDataSource<UITableViewCell,Item>!
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        callToViewModelForUIUpdate()
        self.title = "GITHUB SEARCH"      
    }

    func callToViewModelForUIUpdate() {
        self.searchViewModel =  SearchViewModel()
        self.searchViewModel.bindUsersViewModel = {
                self.updateDataSource()
            }
    }
    
    func setupUI() {
        searchTableView = UITableView(frame: CGRect.zero)
        searchTableView.delegate = self
        searchTableView.rowHeight = 70.0
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        self.view.addSubview(searchTableView)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 0.0),
            searchTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0),
            searchTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0),
            searchTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0)
        ])
        
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "KeyWords"
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        searchTableView.tableHeaderView = searchController.searchBar
        
    }
    
    func updateDataSource(){
            
        self.dataSource = SearchTableViewDataSource(cellIdentifier: "UITableViewCell", items: self.searchViewModel.items, configureCell: { (cell, usr) in
          
        })
            
        DispatchQueue.main.async {
            self.searchTableView.dataSource = self.dataSource
            self.searchTableView.reloadData()
        }
    }

    func reloadData() {
        DispatchQueue.main.async {
        self.searchTableView.reloadData()
        }
    }
}


extension ViewController: UISearchBarDelegate{
    
    /*
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
    }
    */
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
    }
}

extension ViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
            self.searchViewModel.getSearchRepo(keyword: searchController.searchBar.text!) {
                self.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate{

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let height = scrollView.frame.size.height
        let offsetY = scrollView.contentOffset.y
        let distance = scrollView.contentSize.height - offsetY
        if distance < height {
            self.searchViewModel.nextPageSearchRepos {
                self.reloadData()
            }
        }
    }
    
}

//
//  SearchTableViewDataSource.swift
//  GithubSearchApp
//
//  Created by Leo on 2021/06/12.
//

import Foundation

import UIKit

class SearchTableViewDataSource<CELL : UITableViewCell,T> : NSObject, UITableViewDataSource {
    
    private var cellIdentifier : String!
    private var items : [T]!
     
    
    init(cellIdentifier : String, items : [T], configureCell : @escaping (CELL, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let item = self.items[indexPath.row] as! Item
        cell.textLabel?.text = item.fullName
       
        return cell
    }
    
    
}

//
//  SearchGroupTableViewController.swift
//  Vkontakte
//
//  Created by Серёжа on 29/06/2019.
//  Copyright © 2019 appleS. All rights reserved.
//

import UIKit

class SearchGroupTableViewController: UITableViewController {
    
    
    let networkService = NetworkService()
    private var searhGroups = [Group]()
    
    var filteredGroups: [Group]!
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.loadSearchGroups(token: Singleton.instance.token) { [weak self] groups in
            self?.searhGroups = groups
            self?.tableView.reloadData()
        }
        
        filteredGroups = searhGroups
        
        tableView.tableFooterView = UIView()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGroupCell") as! SearchGroupCell
        
        let searchGroup = searhGroups[indexPath.row]
        cell.configure(with: searchGroup)
        
        return cell
    }
}

extension SearchGroupTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredGroups = searhGroups.filter({(groupsSearch: Group) -> Bool in
            return groupsSearch.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

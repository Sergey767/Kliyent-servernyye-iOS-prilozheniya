//
//  SearchGroupTableViewController.swift
//  Vkontakte
//
//  Created by Серёжа on 29/06/2019.
//  Copyright © 2019 appleS. All rights reserved.
//

import UIKit
import RealmSwift

class SearchGroupTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let networkService = NetworkService()
    let realm = try! Realm()
    private let searchGroups = try? Realm().objects(SearchGroup.self)
    private var notificationToken: NotificationToken?
    private var timer: Timer?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        try? realm.write {
            realm.delete(searchGroups!)
        }
        
        notificationToken = searchGroups?.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.update(deletions: deletions, insertions: insertions, modifications: modifications)
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
        setupSearchBar()
        
        tableView.tableFooterView = UIView()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchGroups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGroupCell") as! SearchGroupCell
        
        guard let searchGroup = searchGroups?[indexPath.row] else { return cell }
        cell.configure(with: searchGroup)
        
        return cell
    }
}

// MARK - UISearchBarDelegate
extension SearchGroupTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (_) in
            self.networkService.loadSearchGroups(searchQuery: searchText) { [weak self] searchGroups in
                try? RealmProvider.save(items: searchGroups)
            }
        })
    }
}

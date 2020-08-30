//
//  MyFriendsViewController.swift
//  Vkontakte
//
//  Created by Серёжа on 24/08/2019.
//  Copyright © 2019 appleS. All rights reserved.
//

import UIKit
import RealmSwift

class MyFriendsViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let networkService = NetworkService()
    private let friends = try? Realm().objects(User.self)
    
    var myFriendsDictionary = [String: [User]]()
    var myFriendsSectionTitles = [String]()

    var filteredFriends = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.loadFriends(token: Singleton.instance.token) { [weak self] friends in
            try? RealmProvider.save(items: friends)
            self?.filteredFriends = friends.sorted { $0.lastName < $1.lastName }
            self?.filterTitleFriends()
            self?.tableView.reloadData()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        searchBar.delegate = self
    }
    
    // MARK: - Search Bar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {

            filteredFriends = friends!.sorted { $0.lastName < $1.lastName }
            filterTitleFriends()
            tableView.reloadData()
            return
        }
        filteredFriends = friends!.filter { $0.lastName.lowercased().contains(searchText.lowercased())}
        filteredFriends.sort { $0.lastName < $1.lastName }
        filterTitleFriends()
        tableView.reloadData()
    }

    private func filterTitleFriends() {

        myFriendsDictionary = [:]
        myFriendsSectionTitles = []

        for friend in filteredFriends {
            let friendKey = String(friend.lastName.prefix(1))
            if var friendValues = myFriendsDictionary[friendKey] {
                friendValues.append(friend)
                myFriendsDictionary[friendKey] = friendValues
            } else {
                myFriendsDictionary[friendKey] = [friend]
            }
        }
        myFriendsSectionTitles = [String](myFriendsDictionary.keys)
        myFriendsSectionTitles = myFriendsSectionTitles.sorted(by: { $0 < $1 } )
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoSegue",
            let photoController = segue.destination as? PhotoCollectionViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            let friendKey = myFriendsSectionTitles[indexPath.section]
            if let friendValues = myFriendsDictionary[friendKey] {
                let friendTitle = friendValues[indexPath.row].firstName + " " + friendValues[indexPath.row].lastName
                
                photoController.userId = friendValues[indexPath.row].id
                photoController.friendTitle = friendTitle
            }
        }
    }
}

    // MARK: - Table view data source, delegate methods

extension MyFriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myFriendsSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friendKey = myFriendsSectionTitles[section]
        if let friendValues = myFriendsDictionary[friendKey] {
            return friendValues.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as! MyFriendsCell
        
        let friendKey = myFriendsSectionTitles[indexPath.section]
        if let friendValues = myFriendsDictionary[friendKey] {
        
        let friend = friendValues[indexPath.row]
            cell.configure(with: friend)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return myFriendsSectionTitles[section]
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return myFriendsSectionTitles
    }
}

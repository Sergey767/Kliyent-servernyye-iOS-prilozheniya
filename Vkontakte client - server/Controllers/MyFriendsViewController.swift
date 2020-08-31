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
    var friends: Results<User>?
    private var notificationToken: NotificationToken?
    
    var friendsSectionTitles = [String]()
    var friendsDictionary = [String: [User]]()
    var filterFriends = [User?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.loadFriends(token: Singleton.instance.token) { [weak self] friends in
            //try? RealmProvider.save(items: friends)
        }
        
        friends = try? RealmProvider.get(User.self)
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        
        filterFriends = friends?.sorted { $0.lastName < $1.lastName } as! [User?]
        filterTitleFriends()
        
        notificationToken = friends?.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.update(deletions: deletions, insertions: insertions, modifications: modifications)
            case .error(let error):
                self.show(error)
            }
        }
    }
    
    // MARK: - Search Bar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filterFriends = friends?.sorted { $0.lastName < $1.lastName } as! [User?]
            filterTitleFriends()
            tableView.reloadData()
            return
        }
        
        filterFriends = friends!.filter { $0.lastName.lowercased().contains(searchText.lowercased())}
        filterFriends.sort { $0!.lastName < $1!.lastName}
        filterTitleFriends()
        tableView.reloadData()
    }
    
    private func filterTitleFriends() {
        friendsDictionary = [:]
        friendsSectionTitles = []
        
        for friend in filterFriends {
            guard let friend = friend else { continue }
            guard let friendKey = friend.lastName.compactMap({ String($0) }).first else { return }
            if var friendValues = friendsDictionary[friendKey] {
                friendValues.append(friend)
                friendsDictionary[friendKey] = friendValues
            } else {
                friendsDictionary[friendKey] = [friend]
            }
        }
        friendsSectionTitles = [String](friendsDictionary.keys)
        friendsSectionTitles = friendsSectionTitles.sorted(by: < )
        
        tableView.reloadData()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoSegue",
            let photoController = segue.destination as? PhotoCollectionViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            
                let friendKey = friendsSectionTitles[indexPath.section]
                let friendValues = friendsDictionary[friendKey]
                    
                let friend = friendValues?[indexPath.row]
                    
                photoController.friendTitle = friend!.firstName + " " + friend!.lastName
            
                photoController.userId = friend!.id

            }
    }
}

    // MARK: - Table view data source, delegate methods

extension MyFriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendsSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friendKey = friendsSectionTitles[section]
        if let friendValues = friendsDictionary[friendKey] {
            return friendValues.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as! MyFriendsCell
        
        let friendKey = friendsSectionTitles[indexPath.section]
        if let friendValues = friendsDictionary[friendKey] {
            
            let friend = friendValues[indexPath.row]
            cell.configure(with: friend)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsSectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsSectionTitles
    }
}

//
//  MyGroupsViewController.swift
//  Vkontakte
//
//  Created by Серёжа on 29/06/2019.
//  Copyright © 2019 appleS. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupsViewController: UITableViewController {
    let netrworkService = NetworkService()
    let realm = try! Realm()
    private let groups = try? Realm().objects(Group.self)
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        netrworkService.loadGroups(token: Singleton.instance.token) { [weak self] groups in
            try? RealmProvider.save(items: groups)
        }
        
        notificationToken = groups?.observe { [weak self] change in
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

        tableView.tableFooterView = UIView()
    }
        
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsCell
        
        guard let group = groups?[indexPath.row] else { return  cell }
        cell.configure(with: group)
            
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! MyGroupsCell
        
         let animation = CASpringAnimation(keyPath: "transform.scale")
                      animation.fromValue = 0
                      animation.toValue = 0.5
                      animation.duration = 0.3
                      animation.damping = 0.5
                      animation.initialVelocity = 0
                      animation.stiffness = 200
                      animation.mass = 2
                      animation.fillMode = CAMediaTimingFillMode.backwards
                      animation.isRemovedOnCompletion = false
                    cell.myGroupsImageView.layer.add(animation, forKey: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editingRow = groups?[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _,_ in
            try! self.realm.write {
                self.realm.delete(editingRow!)
            }
        }
        return [deleteAction]
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
//    @IBAction func addGroup(segue: UIStoryboardSegue) {
//            if let controller = segue.source as? SearchGroupViewController,
//                let indexPath = controller.tableView.indexPathForSelectedRow {
//                let group = controller.myGroups[indexPath.row]
//
//                guard !myGroups.contains(where: { $0.nameGroup == group.nameGroup } ) else {return}
//
//                myGroups.append(group)
//                let newIndexPath = IndexPath(item: myGroups.count - 1, section: 0)
//                tableView.insertRows(at: [newIndexPath], with: .automatic)
//            }
//    }
    
}

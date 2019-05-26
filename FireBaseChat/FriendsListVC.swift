//
//  FriendsListVC.swift
//  FireBaseChat
//
//  Created by Bassuni on 5/26/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//

import UIKit

class FriendsListVC: UIViewController {


    @IBOutlet var tv: UITableView!
    var messages = [JSQMessage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.delegate = self
        tv.dataSource = self
        let query = Constants.refs.databaseusers
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            if  let data        = snapshot.value as? [String: String],
                let id          = data["id"],
                let name        = data["userName"]

            {
                if let message = JSQMessage(senderId: id, displayName: name, text: "text")
                {
                    self?.messages.append(message)

                }
            }
        })
        // Do any additional setup after loading the view.
    }
    


}
extension FriendsListVC :  UITableViewDelegate , UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "officialVacationCell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = self.messages[indexPath.row].senderDisplayName
        return cell;
    }

}

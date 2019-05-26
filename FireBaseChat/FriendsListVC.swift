//
//  FriendsListVC.swift
//  FireBaseChat
//
//  Created by Bassuni on 5/26/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//

import UIKit
import Firebase
class FriendsListVC: UIViewController {
    @IBOutlet var tv: UITableView!
    var messages = [friendListData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.delegate = self
        tv.dataSource = self
        let ref = Constants.refs.databaseusers
        // let query2 = ref2.queryOrdered(byChild: "reciverId").queryEqual(toValue: "123")
           DispatchQueue.global(qos: .background).async {
            ref.observe(.value, with: { (snapshot) in
                for childSnapshot in snapshot.children {
                    let c = childSnapshot as! DataSnapshot
                    let dict = c.value as? [String : AnyObject]
                    if let dict = dict
                    {
                        self.messages.append(friendListData(dic: dict))
                         self.tv.reloadData()
                    }

                }
            })
            DispatchQueue.main.async {
                self.tv.reloadData()
            }
        }


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
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) 
        cell.textLabel?.text = self.messages[indexPath.row].name
        return cell;
    }

}


struct friendListData
{
    var name : String
    init(dic : [String : AnyObject]) {
        name = dic["userName"]! as! String
    }
}

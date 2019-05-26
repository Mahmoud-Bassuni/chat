//
//  authenticationVC.swift
//  FireBaseChat
//
//  Created by Bassuni on 5/25/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class authenticationVC: UIViewController {

    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
  var messages = [JSQMessage]()

    @IBAction func loginBtnAction(_ sender: Any) {
        guard emailTxt.text != nil && passwordTxt.text != nil else {return}
    loginUser(email: emailTxt.text!, password: passwordTxt.text!)
    }
    @IBAction func registerBtnAction(_ sender: Any) {
            guard emailTxt.text != nil && passwordTxt.text != nil else {return}
        registerUser(email: emailTxt.text!, password: passwordTxt.text!)
    }

    private func registerUser(email: String, password: String) {
        SVProgressHUD.show(withStatus: "Registering..")
        //create user and wait for callback
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.alert(title: "validation", message: error!.localizedDescription)

            }
            else {
                print(result?.user.uid)
                // if not error, navigate to next page
                let defaults = UserDefaults.standard
                defaults.set(result?.user.uid, forKey: "uid")
                defaults.set(self.emailTxt.text, forKey: "email")
                self.performSegue(withIdentifier: "showChat", sender: self)
            }
            SVProgressHUD.dismiss()
        }
    }

    private func loginUser(email: String, password: String) {
        SVProgressHUD.show(withStatus: "Logging in..")
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.alert(title: "validation", message: error!.localizedDescription)
            }
            else {
                let ref = Constants.refs.databaseusers.childByAutoId()
                let message = ["userName": self.emailTxt.text!, "id": result?.user.uid]
                ref.setValue(message)
                let userID = Auth.auth().currentUser?.uid
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let lat = value?["latitude"] as? Double ?? 0.0
                    let long = value?["longitude"] as? Double ?? 0.0
                })


                let query = Constants.refs.databaseusers
                var x  = query.observe(.childAdded, with: { [weak self] snapshot in
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
                

                let defaults = UserDefaults.standard
                defaults.set(result?.user.uid, forKey: "uid")
                defaults.set(self.emailTxt.text, forKey: "email")
                self.performSegue(withIdentifier: "showChat", sender: self)
            }
            SVProgressHUD.dismiss()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTxt.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
}

extension UIViewController
{
    func alert(title : String, message : String)
    {

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }

}

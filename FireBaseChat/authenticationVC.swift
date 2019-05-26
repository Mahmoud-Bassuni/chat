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
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.alert(title: "validation", message: error!.localizedDescription)

            }
            else {
                // save user in realtime database
                let ref = Constants.refs.databaseusers.childByAutoId()
                let message = ["userName": self.emailTxt.text!, "id": result?.user.uid]
                ref.setValue(message)
                let defaults = UserDefaults.standard
                defaults.set(result?.user.uid, forKey: "uid")
                defaults.set(self.emailTxt.text, forKey: "userName")
                self.performSegue(withIdentifier: "showFriendList", sender: self)
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
                let defaults = UserDefaults.standard
                defaults.set(result?.user.uid, forKey: "uid")
                defaults.set(self.emailTxt.text, forKey: "userName")
                self.performSegue(withIdentifier: "showFriendList", sender: self)
            }
            SVProgressHUD.dismiss()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTxt.isSecureTextEntry = true
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

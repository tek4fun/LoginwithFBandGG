//
//  ForgotPassVC.swift
//  LoginbyFBandGG
//
//  Created by Tu on 5/18/17.
//  Copyright © 2017 MozaTech. All rights reserved.
//

import UIKit

class ForgotPassVC: UIViewController {

    @IBOutlet weak var txt_User: UITextField!
    @IBOutlet weak var txt_Pass: UITextField!
    @IBOutlet weak var btn_Submit: UIButton!
    var users = User.share.users
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_Pass.isEnabled = false
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        btn_Submit.layer.cornerRadius = btn_Submit.frame.height/2
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func btn_Submit(_ sender: Any) {
        if txt_User.text == nil || txt_User.text == "" {
            let alert = UIAlertController(title: "Please Enter User name" , message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if let password = users[txt_User.text!] {
                txt_Pass.text = password
            } else {
                let alert = UIAlertController(title: "User not found", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

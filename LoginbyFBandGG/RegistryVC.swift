//
//  RegistryVC.swift
//  LoginbyFBandGG
//
//  Created by Tu on 5/18/17.
//  Copyright © 2017 MozaTech. All rights reserved.
//

import UIKit

class  RegistryVC: UIViewController {
    
    @IBOutlet weak var txt_User: UITextField!
    @IBOutlet weak var txt_Pass: UITextField!
    @IBOutlet weak var btn_Create: UIButton!
    var users = User.share.users
    var isAgree = false
    var createAccount: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btn_Agreement(_ sender: UIButton) {
        if isAgree == false {
            sender.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            isAgree = true
        } else {
            sender.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            isAgree = false
        }
    }
    
    @IBAction func btn_Create(_ sender: UIButton) {
        if isAgree {
            if users[txt_User.text!] != nil {
                let alert = UIAlertController(title: "Create Failed", message: "User already exists!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if txt_User.text == nil || txt_User.text == "" {
                let alert = UIAlertController(title: "Create Failed", message: "Username must not be whitespace!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if txt_Pass.text == nil || txt_Pass.text == "" {
                let alert = UIAlertController(title: "Create Failed", message: "Password must not be whitespace!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                users[txt_User.text!] = txt_Pass.text!
                let alert = UIAlertController(title: "Create Success", message: "User Create Success", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (completion) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
//                if createAccount != nil {
//                    createAccount!()
//                }
                
            }
        } else {
            let alert = UIAlertController(title: "Create Failed", message: "Agreement has not been accepted!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}

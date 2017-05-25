//
//  leftmenuVC.swift
//  LoginbyFBandGG
//
//  Created by Tu on 5/18/17.
//  Copyright © 2017 MozaTech. All rights reserved.
//

import UIKit

class LeftMenuVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var lb_UserFB: UILabel!
    @IBOutlet weak var img_AvatarGG: UIImageView!
    @IBOutlet weak var lb_UserGG: UILabel!

    var menuItems = ["Main","Sign up","Forgot Pass","Menu 4","Menu 5","Menu 6","Menu 7","Menu 8"]
    var user = User.share.users
    var userFBImage = User.share.userFBImage
    var userFB = User.share.userFB
    var userGG = User.share.userGG
    var userGGImage = User.share.userGGImage
    var isLoginGG = User.share.isLoginGG
    var isLoginFB = User.share.isLoginFB
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        img_Avatar.layer.cornerRadius = img_Avatar.frame.height/2
        img_Avatar.clipsToBounds = true
        img_Avatar.layer.borderWidth = 1
        img_Avatar.layer.borderColor = UIColor.blue.cgColor
        
        img_AvatarGG.layer.cornerRadius = img_Avatar.frame.height/2
        img_AvatarGG.clipsToBounds = true
        img_AvatarGG.layer.borderWidth = 1
        img_AvatarGG.layer.borderColor = UIColor.red.cgColor
    }
    override func viewDidAppear(_ animated: Bool) {
        if isLoginFB {
            img_Avatar.image = userFBImage
            lb_UserFB.text = userFB
        }
        if isLoginGG {
            img_AvatarGG.image = userGGImage
            lb_UserGG.text = userGG
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension LeftMenuVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
}
extension LeftMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.popToRootViewController(animated: true)
        case 1:
            let regVC = storyboard?.instantiateViewController(withIdentifier: "register") as! RegistryVC
            navigationController?.pushViewController(regVC, animated: true)
        case 2:
            let forgotVC = storyboard?.instantiateViewController(withIdentifier: "forgotpass") as! ForgotPassVC
            navigationController?.pushViewController(forgotVC, animated: true)
        default:
            break
        }
    }
}

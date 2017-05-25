//
//  ViewController.swift
//  LoginbyFBandGG
//
//  Created by Tu on 5/16/17.
//  Copyright © 2017 MozaTech. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import SideMenu

let defaults:UserDefaults = UserDefaults.standard
class ViewController: UIViewController,GIDSignInDelegate {
    
    @IBOutlet weak var txt_User: UITextField!
    @IBOutlet weak var txt_Pass: UITextField!
    let paramFB: String = "id, name, email, gender, birthday, age_range, picture.type(large)"
    var users = User.share.users
    var userFBImage = User.share.userFBImage
    var userFB = User.share.userFB
    var userGG = GIDGoogleUser()
    var isLoginGG = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.string(forKey: "userFB") != nil {
            User.share.userFB = defaults.string(forKey: "userFB")!
            User.share.isLoginFB = defaults.bool(forKey: "isLoginFB")

        }
        if defaults.object(forKey: "userFBImage") != nil{
            User.share.userFBImage = UIImage(data: defaults.data(forKey: "userFBImage")!)!
        }
        if defaults.string(forKey: "userGG") != nil {
            User.share.userGG = defaults.string(forKey: "userGG")!
            User.share.isLoginGG = defaults.bool(forKey: "isLoginGG")
        }
        if defaults.object(forKey: "userGGImage") != nil{
            User.share.userGGImage = UIImage(data: defaults.data(forKey: "userGGImage")!)!
        }
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        leftMenu()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotPass(_ sender: Any) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "forgotpass") as! ForgotPassVC
        navigationController?.pushViewController(detail, animated: true)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "register") as! RegistryVC
        navigationController?.pushViewController(detail, animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if let password = users[txt_User.text!] {
            if password == txt_Pass.text {
                let alert = UIAlertController(title: "Login Success" , message: "Login by User: \(txt_User.text!)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else if password != txt_Pass.text{
                let alert = UIAlertController(title: "Login Failed" , message: "User or Password wrong, please try again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Login Failed", message: "User or Password not found!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func loginFaceBook(_ sender: Any) {
        let loginManager = LoginManager()
        if AccessToken.current == nil {
            loginManager.logIn([.publicProfile], viewController: self) { loginResult in
                switch loginResult {
                case .failed(let error):
                    let alert = UIAlertController(title: "Login Failed", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                case .cancelled:
                    let alert = UIAlertController(title: "Login Canceled", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    self.getDataUserToFB(completion: {
                        User.share.isLoginFB = true
                        let alert = UIAlertController(title: "Login Success" , message: "Login with Facebook User: \(User.share.userFB)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.defaults.set(User.share.isLoginFB, forKey: "isLoginFB")
                    })
                }
            }
        } else {
            loginManager.logOut()
            User.share.isLoginFB = false
            User.share.userFB = String()
            User.share.userFBImage = UIImage()
            let alert = UIAlertController(title: "Logout Successful" , message: "Facebook Logout Successful!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.defaults.set(User.share.isLoginFB, forKey: "isLoginFB")
        }
    }
    
    
    func getDataUserToFB(completion: @escaping () -> Void) {
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": paramFB])
        graphRequest.start { (connection, result, error) in
            if error != nil {
                print("Getdata User To FB Error")
                //self.showServerError()
            } else {
                if let dataResult = result as? [String: AnyObject] {
                    print("data user facebook:\(result)")
                    if let user = dataResult["name"] as? String {
                        User.share.userFB = user
                        self.defaults.set(User.share.userFB, forKey: "userFB")
                    }
                    if let picture = dataResult["picture"] {
                        if let data = picture["data"] as? [String:AnyObject] {
                            if let url = data["url"] as? String{
                                //print(url)
                                let pic = try? Data(contentsOf: URL(string: url)!)
                                let avatar = UIImage(data: pic!)!
                                User.share.userFBImage = avatar
                                let imageData = UIImagePNGRepresentation(avatar)
                                self.defaults.set(imageData, forKey: "userFBImage")
                            }
                        }
                    }
                    completion()
                }
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func leftMenu() {
        // Define the menus
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
        SideMenuManager.menuAllowPushOfSameClassTwice = false
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
}
extension ViewController: GIDSignInUIDelegate {
    @IBAction func loginGoogle(_ sender: Any) {
        if isLoginGG {
            GIDSignIn.sharedInstance().signOut()
            let alert = UIAlertController(title: "Logout Success" , message: "Google Logout Successful!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            isLoginGG = false
        } else {
            GIDSignIn.sharedInstance().signIn()
            isLoginGG = true
        }
        User.share.isLoginGG = isLoginGG
        self.defaults.set(User.share.isLoginGG, forKey: "isLoginGG")
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            User.share.userGG = user.profile.name
            self.defaults.set(User.share.userGG, forKey: "userGG")
            
            if user.profile.hasImage {
                let pic = try? Data(contentsOf: user.profile.imageURL(withDimension: 100))
                User.share.userGGImage = UIImage(data: pic!)!
                let avatar = UIImage(data: pic!)!
                let imageData = UIImagePNGRepresentation(avatar)
                //let imageData = UIImageJPEGRepresentation(User.share.userGGImage, 1.0)
                self.defaults.set(imageData, forKey: "userGGImage")
            }
            let alert = UIAlertController(title: "Login Success" , message: "Login with Google User: \(User.share.userGG)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
}

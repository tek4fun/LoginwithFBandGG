//
//  User.swift
//  LoginbyFBandGG
//
//  Created by Tu on 5/22/17.
//  Copyright © 2017 MozaTech. All rights reserved.
//

import UIKit

class User {
    private init() {}
    static let share = User()
    var users = ["admin":"123"]
    var userFB = String()
    var userFBImage = UIImage()
    var userGG = String()
    var userGGImage = UIImage()
    var isLoginFB = false
    var isLoginGG = false
}

//
//  userObject.swift
//  Apollo
//
//  Created by Kevin Thwaits on 4/9/18.
//  Copyright © 2018 Kevin Thwaits. All rights reserved.
//

import Foundation

struct UserObject: Codable {
    
    var display_name:String?
    var email: String
    var id: String
    var images: String
    var room: String
    var access_token: String
    var socket_id: String
    
}

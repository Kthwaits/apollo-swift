//
//  currentlyPlayingObject.swift
//  Apollo
//
//  Created by Kevin Thwaits on 4/7/18.
//  Copyright © 2018 Kevin Thwaits. All rights reserved.
//

import Foundation

struct CurrentlyPlayingObject: Codable {

    var albumArt: String
    var artist: String
    var position: Int
    var song: String
    var track = [String]()
    var duration: Int

}

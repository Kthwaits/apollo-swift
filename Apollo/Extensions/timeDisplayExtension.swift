//
//  timeDisplayExtension.swift
//  Apollo
//
//  Created by Kevin Thwaits on 4/8/18.
//  Copyright © 2018 Kevin Thwaits. All rights reserved.
//

import Foundation

extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d", minute, second)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}

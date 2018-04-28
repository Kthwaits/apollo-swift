//
//  urlExtension.swift
//  Apollo
//
//  Created by Kevin Thwaits on 4/5/18.
//  Copyright © 2018 Kevin Thwaits. All rights reserved.
//

import Foundation

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}

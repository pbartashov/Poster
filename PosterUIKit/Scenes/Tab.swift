//
//  Tab.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 31.10.2022.
//

enum Tab: Int {
    case feed = 0
    case profile
    case favorites

    var index: Int {
        self.rawValue
    }
}

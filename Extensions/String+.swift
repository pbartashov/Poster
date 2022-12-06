//
//  String+.swift
//  Poster
//
//  Created by Павел Барташов on 29.06.2022.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

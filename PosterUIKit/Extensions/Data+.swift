//
//  Data+.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 23.11.2022.
//

import UIKit

extension Data {
    var asImage: UIImage? {
        UIImage(data: self)
    }
}

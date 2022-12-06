//
//  UIColor+.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 09.11.2022.
//

import UIKit

extension UIColor {
    static func makeColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS  13.0, *) else {
            return lightMode
        }

        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
}

extension UIColor {
    static let staticBlack = UIColor(red: 38 / 255, green: 50 / 255, blue: 56 / 255, alpha: 1)
    static let staticDarkGray = UIColor(red: 38 / 255, green: 50 / 255, blue: 56 / 255, alpha: 1)
    static let staticLightGray = UIColor(red: 126 / 255, green: 129 / 255, blue: 131 / 255, alpha: 1)
    static let staticDarkYellow = UIColor(red: 255 / 255, green: 158 / 255, blue: 69 / 255, alpha: 0.7)
    static let staticYellow = UIColor(red: 255 / 255, green: 158 / 255, blue: 69 / 255, alpha: 1)
    static let staticWhite = UIColor(red: 245 / 255, green: 243 / 255, blue: 238 / 255, alpha: 1)

    static var brandTextBlackColor: UIColor {
        Self.makeColor(lightMode: staticBlack, darkMode: .gray)
    }

    static var brandDarkGray: UIColor {
        Self.makeColor(lightMode: staticDarkGray, darkMode: .gray)
    }

    static var brandTextGrayColor: UIColor {
        Self.makeColor(lightMode: staticLightGray, darkMode: .gray)
    }

    static var brandYellowColor: UIColor {
        Self.makeColor(lightMode: staticYellow, darkMode: staticDarkYellow)
    }

    static var brandBackgroundColor: UIColor {
        Self.makeColor(lightMode: .white, darkMode: .black)
    }

    static var brandBackgroundGrayColor: UIColor {
        Self.makeColor(lightMode: staticWhite, darkMode: .black)
    }

    static var brandLightBackgroundColor: UIColor {
        Self.makeColor(lightMode: .white, darkMode: .darkGray)
    }

    static var brandGrayColor: UIColor {
        Self.makeColor(lightMode: staticWhite, darkMode: .darkGray)
    }
}

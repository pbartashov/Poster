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

    static var brandTextBlackColor: UIColor {
        Self.makeColor(lightMode: UIColor(red: 38 / 255, green: 50 / 255, blue: 56 / 255, alpha: 1),
                       darkMode: .gray)
    }

    static var brandLightGray: UIColor {
        Self.makeColor(lightMode: UIColor(red: 217 / 255, green: 217 / 255, blue: 217 / 255, alpha: 1),
                       darkMode: .gray)
    }

    static var brandTextGrayColor: UIColor {
        Self.makeColor(lightMode: UIColor(red: 126 / 255, green: 129 / 255, blue: 131 / 255, alpha: 1),
                       darkMode: .gray)
    }

    static var brandYellowColor: UIColor {
        Self.makeColor(lightMode: UIColor(red: 255 / 255, green: 158 / 255, blue: 69 / 255, alpha: 1),
                       darkMode: .gray)
    }

    static var brandBackgroundColor: UIColor {
        Self.makeColor(lightMode: .white, darkMode: .black)
    }

    static var brandBackgroundGrayColor: UIColor {
        Self.makeColor(lightMode: UIColor(red: 245 / 255, green: 243 / 255, blue: 238 / 255, alpha: 1),
                       darkMode: .black)
    }


//    static var borderColor: UIColor {
//        Self.makeColor(lightMode: .black, darkMode: .lightGray)
//    }








    


    static var lightBackgroundColor: UIColor {
        Self.makeColor(lightMode: .white, darkMode: .darkGray)
    }


    static var shadowColor: UIColor {
        Self.makeColor(lightMode: .black, darkMode: .darkGray)
    }

    static var textColor: UIColor {
        Self.makeColor(lightMode: .black, darkMode: .white)
    }

    static var secondaryTextColor: UIColor {
        Self.makeColor(lightMode: .gray, darkMode: .lightGray)
    }

    static var lightTextColor: UIColor {
        Self.makeColor(lightMode: .white, darkMode: .lightGray)
    }

    static var placeholderTextColor: UIColor {
        Self.makeColor(lightMode: .gray, darkMode: .lightGray)
    }
}


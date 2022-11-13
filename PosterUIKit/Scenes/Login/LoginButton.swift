//
//  LoginButton.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 12.11.2022.
//

enum LoginButton {
    case signUp
    case signIn
    case next
    case confirm

    var title: String {
        switch self {
            case .signUp:
                return "signUpLoginButton".localized

            case .signIn:
                return "signInLoginButton".localized

            case .next:
                return "nextLoginButton".localized

            case .confirm:
                return "confirmLoginButton".localized
        }
    }
}

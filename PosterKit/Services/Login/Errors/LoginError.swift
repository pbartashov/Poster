//
//  LoginError.swift
//  Poster
//
//  Created by Павел Барташов on 09.11.2022.
//

import Foundation

enum LoginError: Error {
    case missingPhoneNumber
    case missingCode
//    case missingPassword
    case invalidPhoneNumber
    case invalidCode
//    case wrongPassword
//    case weakPassword
    case userNotFound
    case networkError
    case unknown
}

extension LoginError : LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .missingPhoneNumber:
                return "missingPhoneNumberLoginError".localized

            case .missingCode:
                return "missingCodeLoginError".localized

//            case .missingPassword:
//                return "missingPasswordLoginError".localized

            case .invalidPhoneNumber:
                return "invalidPhoneNumberLoginError".localized

            case .invalidCode:
                return "invalidCodeLoginError".localized

//            case .wrongPassword:
//                return "wrongPasswordLoginError".localized
//
//            case .weakPassword:
//                return "weakPasswordLoginError".localized

            case .userNotFound:
                return "userNotFoundLoginError".localized

            case .networkError:
                return "networkErrorLoginError".localized

            case .unknown:
                return "unknownLoginError".localized
        }
    }
}

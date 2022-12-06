//
//  ChekerService.swift
//  PosterKit
//
//  Created by Павел Барташов on 09.11.2022.
//

import FirebaseAuth

public protocol CheckerServiceProtocol {
    func signIn(phoneNumber: String,
                completion: ((Result<String, Error>) -> Void)?)

    func signUp(phoneNumber: String,
                completion: ((Result<String, Error>) -> Void)?)

    func comfirmPhoneNumberWith(code: String,
                                completion: ((Result<String, Error>) -> Void)?)
}

public struct ChekerService: CheckerServiceProtocol {

    // MARK: - LifeCicle

    public init() { }

    // MARK: - Metods

    private func clean(phoneNumber: String) -> String {
        let digits = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return "+\(digits)"
    }

    public func signIn(phoneNumber: String, completion: ((Result<String, Error>) -> Void)?) {
        let phoneNumber = clean(phoneNumber: phoneNumber)
        if let user = Auth.auth().currentUser,
           user.phoneNumber == phoneNumber {
            completion?(.success(user.uid))
        } else {
            completion?(.failure(LoginError.invalidPhoneNumber))
        }
    }

    public func signUp(phoneNumber: String, completion: ((Result<String, Error>) -> Void)?) {
        let phoneNumber = clean(phoneNumber: phoneNumber)
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    handle(error: error, completion: completion)
                    return
                }
                UserDefaults.standard.set(verificationID, forKey: Constants.Login.authVerificationID)
                completion?(.success(phoneNumber))
            }
    }

    public func comfirmPhoneNumberWith(code: String, completion: ((Result<String, Error>) -> Void)?) {
        if let verificationID = UserDefaults.standard.string(forKey: Constants.Login.authVerificationID) {
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: code
            )

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    handle(error: error, completion: completion)
                    return
                }

                guard let user = authResult?.user else {
                    completion?(.failure(LoginError.unknown))
                    return
                }
                completion?(.success(user.uid))
            }
        }
    }

    private func handle(error: Error, completion: ((Result<String, Error>) -> Void)?) {
        if let error = error as? AuthErrorCode {
            completion?(.failure(error.toLoginError))
        } else {
            completion?(.failure(error))
        }
    }
}

fileprivate extension AuthErrorCode {
    var toLoginError: LoginError {
        switch self.code {
            case .missingPhoneNumber:
                return .missingPhoneNumber

            case .invalidPhoneNumber:
                return .invalidPhoneNumber

            case .missingVerificationCode:
                return .missingCode

            case  .invalidVerificationCode:
                return .invalidCode

            default:
                return .unknown
        }
    }
}

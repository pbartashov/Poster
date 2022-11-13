//
//  LoginInspector.swift
//  Poster
//
//  Created by Павел Барташов on 09.11.2022.
//

public protocol LoginDelegate: AnyObject {
    func checkCredentials(phoneNumber: String,
                          completion: ((Result<String, Error>) -> Void)?)

    func signUp(phoneNumber: String,
                completion: ((Result<String, Error>) -> Void)?)

    func comfirmPhoneNumberWith(code: String,
                completion: ((Result<String, Error>) -> Void)?)

}

public final class LoginInspector: LoginDelegate {

    // MARK: - Properties

    private let checker: CheckerServiceProtocol


    // MARK: - LifeCicle

    public init(checker: CheckerServiceProtocol) {
        self.checker = checker
    }

    // MARK: - Metods

    public func checkCredentials(phoneNumber: String, completion: ((Result<String, Error>) -> Void)?) {
        if phoneNumber.isEmpty {
            completion?(.failure(LoginError.missingPhoneNumber))
            return
        }

        checker.checkCredentials(phoneNumber: phoneNumber, completion: completion)
    }

    public func signUp(phoneNumber: String, completion: ((Result<String, Error>) -> Void)?) {
        if phoneNumber.isEmpty {
            completion?(.failure(LoginError.missingPhoneNumber))
            return
        }

        checker.signUp(phoneNumber: phoneNumber, completion: completion)
    }

    public func comfirmPhoneNumberWith(code: String, completion: ((Result<String, Error>) -> Void)?) {
        if code.isEmpty {
            completion?(.failure(LoginError.missingCode))
            return
        }

        checker.comfirmPhoneNumberWith(code: code, completion: completion)
    }

}

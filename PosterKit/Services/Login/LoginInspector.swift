//
//  LoginInspector.swift
//  Poster
//
//  Created by Павел Барташов on 09.11.2022.
//

public protocol LoginDelegate: AnyObject {
    func signIn(phoneNumber: String,
                completion: ((Result<User, Error>) -> Void)?)

    func signUp(phoneNumber: String,
                completion: ((Result<String, Error>) -> Void)?)

    func comfirm(phoneNumber: String,
                 withCode code: String,
                 completion: ((Result<User, Error>) -> Void)?)
}

public final class LoginInspector: LoginDelegate {

    // MARK: - Properties

    private let checker: CheckerServiceProtocol
    private let userService: UserServiceProtocol

    // MARK: - LifeCicle

    public init(checker: CheckerServiceProtocol,
                userService: UserServiceProtocol
    ) {
        self.checker = checker
        self.userService = userService
    }

    // MARK: - Metods

    public func signIn(phoneNumber: String, completion: ((Result<User, Error>) -> Void)?) {
        if phoneNumber.isEmpty {
            completion?(.failure(LoginError.missingPhoneNumber))
            return
        }

        checker.signIn(phoneNumber: phoneNumber) { [weak self] result in
            switch result {
                case .failure(let error):
                    completion?(.failure(error))

                case let .success(userId):
                    self?.hanldeSignIn(userId: userId,
                                       phoneNumber: phoneNumber,
                                       completion: completion)
            }
        }
    }

    public func signUp(phoneNumber: String, completion: ((Result<String, Error>) -> Void)?) {
        if phoneNumber.isEmpty {
            completion?(.failure(LoginError.missingPhoneNumber))
            return
        }

        checker.signUp(phoneNumber: phoneNumber, completion: completion)
    }

    public func comfirm(phoneNumber: String,
                        withCode code: String,
                        completion: ((Result<User, Error>) -> Void)?
    ) {
        if code.isEmpty {
            completion?(.failure(LoginError.missingCode))
            return
        }

        checker.comfirmPhoneNumberWith(code: code) { [weak self] result in
            switch result {
                case .failure(let error):
                    completion?(.failure(error))

                case let .success(userId):
                    self?.hanldeSignIn(userId: userId,
                                       phoneNumber: phoneNumber,
                                       completion: completion)
            }
        }
    }

    private func hanldeSignIn(userId: String,
                              phoneNumber: String,
                              completion: ((Result<User, Error>) -> Void)?
    ) {
        Task { [userService] in
            do {
                try await userService.setCurrentUser(byId: userId, phoneNumber: phoneNumber)

                if let user = userService.currentUser {
                    completion?(.success(user))
                } else {
                    completion?(.failure(DatabaseError.notFound))
                }
            } catch {
                completion?(.failure(error))
            }
        }
    }
}

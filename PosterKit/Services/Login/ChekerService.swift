//
//  ChekerService.swift
//  PosterKit
//
//  Created by Павел Барташов on 09.11.2022.
//

public protocol CheckerServiceProtocol {
    func checkCredentials(phoneNumber: String,
                          completion: ((Result<String, Error>) -> Void)?)

    func signUp(phoneNumber: String,
                completion: ((Result<String, Error>) -> Void)?)

    func comfirmPhoneNumberWith(code: String,
                completion: ((Result<String, Error>) -> Void)?)
}

public struct ChekerService: CheckerServiceProtocol {
    // MARK: - Properties

    // MARK: - Views

    // MARK: - LifeCicle

    public init() {
        
    }

    // MARK: - Metods

    public func checkCredentials(phoneNumber: String, completion: ((Result<String, Error>) -> Void)?) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            completion?(.success("dadas"))
        }
    }

    public func signUp(phoneNumber: String, completion: ((Result<String, Error>) -> Void)?) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            completion?(.success("dadas"))
        }
    }

    public func comfirmPhoneNumberWith(code: String, completion: ((Result<String, Error>) -> Void)?) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            completion?(.success("dadas"))
        }
    }
}


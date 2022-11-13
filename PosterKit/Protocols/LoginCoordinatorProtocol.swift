//
//  LoginCoordinatorProtocol.swift
//  PosterKit
//
//  Created by Павел Барташов on 09.11.2022.
//

public protocol LoginCoordinatorProtocol: AnyObject {
    func showWelcomeScene()
    func showSignUpScene()
    func showConfirmSignUpScene(for phoneNumber: String)
    func showSignInScene()
    func showMainScene(for userName: String)
}

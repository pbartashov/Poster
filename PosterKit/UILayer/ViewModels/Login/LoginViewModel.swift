//
//  LoginViewModel.swift
//  Poster
//
//  Created by Павел Барташов on 09.11.2022.
//

import Combine

public typealias PhoneNumberAndCode = (phoneNumber: String, code: String)

public enum LoginAction {
    case start
    case showSignUp
    case showSignIn
    case authWith(phoneNumber: String)
    case signUpWith(phoneNumber: String)
    case comfirm(PhoneNumberAndCode)



//    case autoLogin

}

public enum LoginState {
    case initial
    case missingPhoneNumber
    case missingCode
//    case wrongPhoneNumber
    case authFailed
//    case processing(phoneNumber: String)
    case processing//(LoginAction)

//    case authSucceeded(User)

}

#warning("PublishedViewModelProtocol")
public protocol LoginViewModelProtocol {
    var statePublisher: Published<LoginState>.Publisher { get }
//    var state: LoginState { get }

    func perfomAction(_ action: LoginAction)

}

public final class LoginViewModel: LoginViewModelProtocol {

    // MARK: - Properties
    
    private var loginDelegate: LoginDelegate?
    private weak var coordinator: LoginCoordinatorProtocol?
//    private var credentialStorage: CredentialStorageProtocol?
    private let errorPresenter: ErrorPresenterProtocol

    @Published public var state: LoginState = .initial
    public var statePublisher: Published<LoginState>.Publisher { $state }

    // MARK: - LifeCicle
    
    public init(loginDelegate: LoginDelegate,
         coordinator: LoginCoordinatorProtocol?,
//         credentialStorage: CredentialStorageProtocol,
         errorPresenter: ErrorPresenterProtocol
    ) {
        
        self.loginDelegate = loginDelegate
        self.coordinator = coordinator
//        self.credentialStorage = credentialSto
        self.errorPresenter = errorPresenter
    }
    
    // MARK: - Metods
    
    public func perfomAction(_ action: LoginAction) {
        switch action {
            case .start:
//                showWelcome()
                checkAuthFor(phoneNumber: "+1 (650) 555-35-35")




            case .showSignIn:
                showSignIn()

            case .showSignUp:
                showSignUp()

            case .authWith(let phoneNumber):
                checkAuthFor(phoneNumber: phoneNumber)

            case .signUpWith(let phoneNumber):
                signUpWith(phoneNumber: phoneNumber)

            case let .comfirm((phoneNumber, code)):
                comfirmWith(phoneNumber: phoneNumber, code: code)



//            case let .showSignIn(login: login, password: password):
//                checkAuth(forLogin: login, password: password)


        }
    }

    private func showWelcome() {
        coordinator?.showWelcomeScene()



        
//        Post.storeMock()
    }

    private func showSignUp() {
        coordinator?.showSignUpScene()
    }

    private func showSignIn() {
        coordinator?.showSignInScene()
    }

    private func checkAuthFor(phoneNumber: String) {
        state = .processing
        //(.authWith(phoneNumber: phoneNumber))
        loginDelegate?.signIn(phoneNumber: phoneNumber) { [weak self] result in
            self?.handleSignIn(result: result)
        }
    }

    private func signUpWith(phoneNumber: String) {
        state = .processing
        //(.signUpWith(phoneNumber: phoneNumber))
        loginDelegate?.signUp(phoneNumber: phoneNumber) { [weak self] result in
            self?.handleSignUp(result: result)
        }
    }

    private func comfirmWith(phoneNumber: String, code: String) {
        state = .processing
        //(.comfirmPhoneNumberWith(code: code))
        loginDelegate?.comfirm(phoneNumber: phoneNumber, withCode: code) { [weak self] result in
            self?.handleSignIn(result: result)
        }
    }


//    private func showCreateAccount(withPhoneNumber phoneNumber: String) {
//        fatalError("Not implemented")
//#warning("Not implemented")
////        coordinator?.showCreateAccount(for: phoneNumber) { [weak self] in
////            self?.signUp(withPhoneNumber: phoneNumber)
////        }
////    }
//    }




    private func handleSignUp(result: Result<String, Error>
//                        phoneNumberOrCode: String
    ) {
        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
            switch result {
                case .failure(let error):
                    self?.handle(error: error)

                case .success(let code):
//                    if case let .processing(action) = self.state {
//                        self.handle(action: action, result: phoneOrCode)
//                    }
                    self?.state = .initial
                    self?.coordinator?.showConfirmSignUpScene(for: code)
           }
        }
    }

    private func handleSignIn(result: Result<User, Error>) {
        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
            switch result {
                case .failure(let error):
                    self?.handle(error: error)

                case .success(let user):
//                    self.state = .authSuccessed(user)
                    self?.coordinator?.showMainScene(for: user)
            }
        }
    }

    private func handle(error: Error) {
        switch error {
            case LoginError.missingPhoneNumber:
                self.handle(error: LoginError.missingPhoneNumber, state: .missingPhoneNumber)

            case LoginError.missingCode:
                self.handle(error: LoginError.missingCode, state: .missingCode)

            default:
                self.handle(error: error, state: .authFailed)
        }
    }


    private func handle(error: Error, state: LoginState) {
        self.state = state
        errorPresenter.show(error: error)
    }

//    private func handle(action: LoginAction, result: String = "") {
//        switch action {
//            case .authWith, .comfirmPhoneNumberWith:
//                coordinator?.showMainScene(for: result)
//
//            case .signUpWith:
//                coordinator?.showConfirmSignUpScene(for: code)
//
//            default:
//                break
//        }
//    }
}

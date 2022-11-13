//
//  LoginViewModel.swift
//  Poster
//
//  Created by Павел Барташов on 09.11.2022.
//

import Combine

public enum LoginAction {
    case start
    case showSignUp
    case showSignIn
    case authWith(phoneNumber: String)
    case signUpWith(phoneNumber: String)
    case comfirmPhoneNumberWith(code: String)



//    case autoLogin

}

public enum LoginState {
    case initial
    case missingPhoneNumber
    case wrongPhoneNumber
    case authFailed
//    case processing(phoneNumber: String)
    case processing(LoginAction)

}

public protocol LoginViewModelProtocol {
//  var state: AnyPublisher<LoginState, Never> { get }
    var state: LoginState { get }

    func perfomAction(_ action: LoginAction)

}

public final class LoginViewModel: LoginViewModelProtocol {
    @Published public var state: LoginState = .initial

    //MARK: - Properties
    
    private var loginDelegate: LoginDelegate?
    private weak var coordinator: LoginCoordinatorProtocol?
//    private var credentialStorage: CredentialStorageProtocol?
    private let errorPresenter: ErrorPresenterProtocol


    //MARK: - LifeCicle
    
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
    
    //MARK: - Metods
    
    public func perfomAction(_ action: LoginAction) {
        switch action {
            case .start:
                showWelcome()

            case .showSignIn:
                showSignIn()

            case .showSignUp:
                showSignUp()

            case .authWith(let phoneNumber):
                checkAuthFor(phoneNumber: phoneNumber)

            case .signUpWith(let phoneNumber):
                signUpWith(phoneNumber: phoneNumber)

            case .comfirmPhoneNumberWith(let code):
                comfirmPhoneNumberWith(code: code)



//            case let .showSignIn(login: login, password: password):
//                checkAuth(forLogin: login, password: password)


        }
    }

    private func showWelcome() {
        coordinator?.showWelcomeScene()
    }

    private func showSignUp() {
        coordinator?.showSignUpScene()
    }

    private func showSignIn() {
        coordinator?.showSignInScene()
    }




    private func checkAuthFor(phoneNumber: String) {
        state = .processing(.authWith(phoneNumber: phoneNumber))
        loginDelegate?.checkCredentials(phoneNumber: phoneNumber) { [weak self] result in
            self?.handle(result: result, phoneNumberOrCode: phoneNumber)
        }
    }

    private func signUpWith(phoneNumber: String) {
        state = .processing(.signUpWith(phoneNumber: phoneNumber))
        loginDelegate?.signUp(phoneNumber: phoneNumber) { [weak self] result in
            self?.handle(result: result, phoneNumberOrCode: phoneNumber)
        }
    }

    private func comfirmPhoneNumberWith(code: String) {
        state = .processing(.comfirmPhoneNumberWith(code: code))
        loginDelegate?.comfirmPhoneNumberWith(code: code) { [weak self] result in
            self?.handle(result: result, phoneNumberOrCode: code)
        }
    }


    private func showCreateAccount(withPhoneNumber phoneNumber: String) {
        fatalError("Not implemented")
#warning("Not implemented")
//        coordinator?.showCreateAccount(for: phoneNumber) { [weak self] in
//            self?.signUp(withPhoneNumber: phoneNumber)
//        }
//    }
    }




    private func handle(result: Result<String, Error>,
                        phoneNumberOrCode: String
    ) {
        switch result {
            case .failure(LoginError.missingPhoneNumber):
                handle(error: LoginError.missingPhoneNumber, state: .missingPhoneNumber)

//            case .failure(LoginError.missingPassword):
//                handle(error: LoginError.missingPassword, state: .wrongPassword)

//            case .failure(LoginError.weakPassword):
//                handle(error: LoginError.weakPassword, state: .wrongPassword)

            case .failure(LoginError.userNotFound):
                showCreateAccount(withPhoneNumber: phoneNumberOrCode)
                
            case .failure(let error):
                handle(error: error, state: .authFailed)

            case .success(let phoneNumberOrCode):
                if case let .processing(action) = state {
                    handle(action: action, phoneNumberOrCode: phoneNumberOrCode)
                }
        }
    }

    private func handle(error: Error, state: LoginState) {
        self.state = state
        errorPresenter.show(error: error)
    }

    private func handle(action: LoginAction, phoneNumberOrCode: String) {
        switch action {
            case .authWith, .comfirmPhoneNumberWith:
                coordinator?.showMainScene(for: phoneNumberOrCode)

            case .signUpWith:
                coordinator?.showConfirmSignUpScene(for: phoneNumberOrCode)

            default:
                break
        }
    }
}

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
}

public enum LoginState {
    case initial
    case missingPhoneNumber
    case missingCode
    case authFailed
    case processing
}

public protocol LoginViewModelProtocol: ViewModelProtocol
where State == LoginState,
      Action == LoginAction  {
}

public final class LoginViewModel: ViewModel<LoginState, LoginAction>,
                                   LoginViewModelProtocol {
    // MARK: - Properties
    
    private var loginDelegate: LoginDelegate?
    private weak var coordinator: LoginCoordinatorProtocol?

    // MARK: - LifeCicle
    
    public init(loginDelegate: LoginDelegate,
                coordinator: LoginCoordinatorProtocol?,
                errorPresenter: ErrorPresenterProtocol
    ) {
        self.loginDelegate = loginDelegate
        self.coordinator = coordinator
        super.init(state: .initial, errorPresenter: errorPresenter)
    }
    
    // MARK: - Metods
    
    public override func perfomAction(_ action: LoginAction) {
        switch action {
            case .start:
//                showWelcome()
                checkAuthFor(phoneNumber: "+1 650-555-3535")
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
        state = .processing
        loginDelegate?.signIn(phoneNumber: phoneNumber) { [weak self] result in
            self?.handleSignIn(result: result)
        }
    }

    private func signUpWith(phoneNumber: String) {
        state = .processing
        loginDelegate?.signUp(phoneNumber: phoneNumber) { [weak self] result in
            self?.handleSignUp(result: result)
        }
    }

    private func comfirmWith(phoneNumber: String, code: String) {
        state = .processing
        loginDelegate?.comfirm(phoneNumber: phoneNumber, withCode: code) { [weak self] result in
            self?.handleSignIn(result: result)
        }
    }

    private func handleSignUp(result: Result<String, Error>) {
        DispatchQueue.main.async { [weak self] in
            switch result {
                case .failure(let error):
                    self?.handle(error: error)

                case .success(let code):
                    self?.state = .initial
                    self?.coordinator?.showConfirmSignUpScene(for: code)
            }
        }
    }

    private func handleSignIn(result: Result<User, Error>) {
        DispatchQueue.main.async { [weak self] in
            switch result {
                case .failure(let error):
                    self?.handle(error: error)

                case .success(let user):
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
}

//
//  WelcomeViewController.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 12.11.2022.
//

import UIKit
import PosterKit
import Combine

final class WelcomeViewController: UIViewController {

    // MARK: - Properties

    private var viewModel: LoginViewModelProtocol

    private var buttonTappedSubsription: AnyCancellable?

    // MARK: - Views

    private lazy var welcomeView: WelcomeView = {
        let viewFactory = LoginViewFactory()
        return WelcomeView(viewFactory: viewFactory)
    }()

    private let scrollView = UIScrollView()

    // MARK: - LifeCicle

    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func loadView() {
//        view = welcomeView
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    // MARK: - Metods

    private func initialize() {
        view.backgroundColor = .systemBackground

        //        navigationController?.navigationBar.isHidden = true

        scrollView.addSubview(welcomeView)
        view.addSubview(scrollView)

        setupLayout()
        setupViewModel()
    }

    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        welcomeView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }

    private func setupViewModel() {
        buttonTappedSubsription = welcomeView.buttonTappedPublisher
            .compactMap { $0.toAction }
            .sink { [weak self] action in
                self?.viewModel.perfomAction(action)
            }
    }
}

fileprivate extension LoginButton {
    var toAction: LoginAction? {
        switch self {
            case .signUp:
                return .showSignUp

            case .signIn:
                return .showSignIn

            default:
                return nil
        }
    }
}

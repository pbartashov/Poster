//
//  SignActionView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 13.11.2022.
//

import UIKit
import Combine
import SnapKit

class SignActionView: ViewWithButton<LoginButton> {

    // MARK: - Properties

    let viewFactory: ViewFactoryProtocol
    let loginButton: LoginButton

    var text: String {
        get {
            textField.text ?? ""
        }
        set {
            textField.text = newValue
        }
    }

    var isBusy: Bool {
        get {
            !activityView.isHidden
        }
        set {
            activityView.isHidden = !newValue
        }
    }

    // MARK: - Views

    lazy var textField: UITextField = {
        let textField = viewFactory.makeTextField()
        return textField
    }()

    lazy var actionButton: UIButton = {
        let action = UIAction(title: loginButton.title) { [weak self] _ in
            guard let self = self else { return }
            self.sendButtonTapped(self.loginButton)
        }

        return viewFactory.makeBlackFilledButton(action: action)
    }()

    lazy var activityView: UIActivityIndicatorView = {
        let activity = viewFactory.makeActivityIndicatorView()
        return activity
    }()

    // MARK: - LifeCicle

    init(viewFactory: ViewFactoryProtocol,
         loginButton: LoginButton
    ) {
        self.viewFactory = viewFactory
        self.loginButton = loginButton
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

    private func initialize() {
        [textField,
         actionButton,
         activityView
        ].forEach {
            self.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        activityView.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.centerX.equalToSuperview()
        }
    }

    private func shake(view: UIView) {
        view.transform = CGAffineTransform(translationX: 10, y: 0)

        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1,
                       options: [], animations: {
            view.transform = .identity
        }, completion: nil )
    }

    func shakeTextField() {
        shake(view: textField)
    }

    func shakeActionButton() {
        shake(view: actionButton)
    }
}

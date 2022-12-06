//
//  LoginViewController.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 12.11.2022.
//

import UIKit
import PosterKit

final class LoginViewController<T: LoginViewModelProtocol>: UINavigationController {

    typealias ViewModelType = T

    // MARK: - Properties

    private var viewModel: ViewModelType

    // MARK: - LifeCicle

    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.perfomAction(.start)
    }
}

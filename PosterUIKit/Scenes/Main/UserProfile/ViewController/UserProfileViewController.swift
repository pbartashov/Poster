//
//  UserProfileViewController.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 27.11.2022.
//

import UIKit
import PosterKit

final class UserProfileViewController: ScrollableViewController<UserProfileViewModelProtocol> {

    // MARK: - Views

    private lazy var userProfileView: UserProfileView = {
        let viewFactory = ViewFactory()
        return UserProfileView(viewFactory: viewFactory, imagePickerViewDelegate: self)
    }()

    // MARK: - LifeCicle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    // MARK: - Metods

    private func initialize() {
        super.addSubViewToScrollView(userProfileView)
        title = "titleUserProfileViewController".localized
        setupBarItems()
        bindViewModel()
        setupView()
    }

    private func setupBarItems() {
        let dismissAction = UIAction { [weak self] _ in
            self?.viewModel.perfomAction(.dissmiss)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Cancel"),
                                                           primaryAction: dismissAction)
        navigationItem.leftBarButtonItem?.tintColor = .brandYellowColor

        let saveAction = UIAction { [weak self] _ in
            guard let self = self,
                  let user = self.makeUser()
            else {
                return
            }
            self.viewModel.perfomAction(.save(user: user))
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "CheckMark"),
                                                            primaryAction: saveAction)
        navigationItem.rightBarButtonItem?.tintColor = .brandYellowColor
    }

    private func bindViewModel() {
        viewModel.datePlaceHolderPublisher
            .assign(to: \.datePlaceHolder, on: userProfileView)
            .store(in: &subsriptions)

        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .map { $0 == .saving }
            .assign(to: \.isBusy, on: userProfileView)
            .store(in: &subsriptions)
    }

    private func makeUser() -> User? {
        var user = viewModel.user
        user?.firstName = extract(userProfileView.firstName)
        user?.lastName = extract(userProfileView.lastName)
        user?.phoneNumber = extract(userProfileView.phoneNumber)
        user?.status = extract(userProfileView.status)
        user?.nativeTown = extract(userProfileView.nativeTown)
        user?.avatarData = userProfileView.avatarData
        user?.gender = userProfileView.gender
        user?.birthDate = viewModel.makeDate(from: userProfileView.birthDate)

        return user
    }

    private func extract(_ text: String?) -> String? {
        text?.isEmpty == false ? text : nil
    }

    private func setupView() {
        if let user = viewModel.user {
            userProfileView.firstName = user.firstName
            userProfileView.lastName = user.lastName
            userProfileView.phoneNumber = user.phoneNumber
            userProfileView.avatarData = user.avatarData
            userProfileView.status = user.status
            userProfileView.nativeTown = user.nativeTown
            userProfileView.gender = user.gender
            userProfileView.birthDate = viewModel.makeText(from: user.birthDate)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate methods
extension UserProfileViewController: ImagePickerViewDelegate {
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }

    func dismiss() {
        dismiss(animated: true)
    }
}

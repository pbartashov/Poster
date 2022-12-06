//
//  ProfileCoordinator.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit
import PosterKit

final class ProfileCoordinator: NavigationCoordinator, ProfileCoordinatorProtocol {

    // MARK: - Properties

    var dependancyContainer: ProfileDependancyContainerProtocol?

    // MARK: - Metods

    func showPhotos() {
        let photosViewController = dependancyContainer?.makePhotosViewController()
        pushViewController(photosViewController)
    }

    func showUserProfile() {
        if let userProfileViewController = dependancyContainer?.makeUserProfileViewController() {
            let navigationViewController = UINavigationController(rootViewController: userProfileViewController)
            presentViewController(navigationViewController)
        }
    }

    func showAddPhoto() {
        let addPhotoViewController = dependancyContainer?.makeAddPhotoViewController()
        presentViewController(addPhotoViewController)
    }
}

extension ProfileCoordinator: DetailedPostCoordinatorProtocol {
    func dismissDetailedPost() {
        pop(animated: true)
    }
}

extension ProfileCoordinator: UserProfileCoordinatorProtocol {
    func dismissUserProfile() {
        dismiss(animated: true)
    }
}

extension ProfileCoordinator: AddPhotoCoordinatorProtocol {
    func dismissAddPhoto() {
        dismiss(animated: true)
    }
}

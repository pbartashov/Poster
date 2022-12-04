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

    // MARK: - LifeCicle

//    init(navigationController: UINavigationController? = nil,
//         profileDependancyContainer: ProfileDependancyContainerProtocol) {
//        self.profileDependancyContainer = profileDependancyContainer
//        super.init(navigationController: navigationController)
//    }

    // MARK: - Metods

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

//    func dismissUserProfile() {
//        dismiss(animated: true)
//    }

    func showAddPhoto() {
        let addPhotoViewController = dependancyContainer?.makeAddPhotoViewController()
        presentViewController(addPhotoViewController)
    }

//    func showImagePicker() {
//        if let imagePickerController = dependancyContainer?.makeImagePickerViewController() {
//            presentViewController(imagePickerController)
//        }
//    }
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

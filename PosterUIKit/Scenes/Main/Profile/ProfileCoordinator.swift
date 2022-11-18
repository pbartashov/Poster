//
//  ProfileCoordinator.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit
import PosterKit

final class ProfileCoordinator: NavigationCoordinator, ProfileCoordinatorProtocol {

    //MARK: - Metods

    func showPhotos() {
        let photosViewController = PhotosViewController()
        navigationController?.pushViewController(photosViewController, animated: true)
    }
}

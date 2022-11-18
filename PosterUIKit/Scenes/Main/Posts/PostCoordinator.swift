//
//  PostCoordinator.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import UIKit

protocol PostCoordinatorProtocol {
    func showInfo()
}

final class PostCoordinator: NavigationCoordinator, PostCoordinatorProtocol {

    //MARK: - Metods

    func showInfo() {
//        let infoViewController = InfoViewController()
//        navigationController?.present(infoViewController, animated: true, completion: nil)
    }
}


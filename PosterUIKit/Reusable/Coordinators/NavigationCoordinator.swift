//
//  Coordinator.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 09.07.2022.
//

import UIKit

class NavigationCoordinator {

    //MARK: - Properties

    weak var navigationController: UINavigationController?

    //MARK: - LifeCicle

    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }

    //MARK: - Metods

    func pop(animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: animated)
        }
    }

    func dismiss(animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.dismiss(animated: animated)
        }
    }

    func pushViewController(_ viewController: UIViewController?, animated: Bool = true) {
        guard let viewController = viewController else {
            return
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }

    func presentViewController(_ viewController: UIViewController?, animated: Bool = true) {
        guard let viewController = viewController else {
            return
        }
        DispatchQueue.main.async {
            self.navigationController?.present(viewController, animated: animated)
        }
    }
}

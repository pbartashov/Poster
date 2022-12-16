//
//  Presenter.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 11.12.2022.
//

import UIKit

protocol Presenter: AnyObject {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

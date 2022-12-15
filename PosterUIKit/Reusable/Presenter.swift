//
//  Presenter.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 11.12.2022.
//

import UIKit

protocol Presenter: AnyObject {
//    var view: UIView! { get set }
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
//    func addChild(_ childController: UIViewController)
//    func didMove(toParent parent: UIViewController?)



//    func willMove(toParent parent: Presenter?)
//
//    
//    func removeFromParent()
}

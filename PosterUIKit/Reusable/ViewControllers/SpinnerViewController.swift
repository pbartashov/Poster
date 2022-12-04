//
//  SpinnerViewController.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 04.12.2022.
//

import UIKit

//https://www.hackingwithswift.com/example-code/uikit/how-to-use-uiactivityindicatorview-to-show-a-spinner-when-work-is-happening
final class SpinnerViewController: UIViewController {

    // MARK: - Properties

    var color: UIColor {
        get { activityView.color }
        set { activityView.color = newValue }
    }

    // MARK: - Views

    lazy var activityView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.startAnimating()
        activity.translatesAutoresizingMaskIntoConstraints = false

        return activity
    }()

    // MARK: - LifeCicle
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.85)
        view.addSubview(activityView)

        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }


    // MARK: - Metods

    func showSpinner(for viewController: UIViewController) {
        viewController.addChild(self)
        viewController.view.addSubview(view)
        didMove(toParent: viewController)
        view.frame = viewController.view.frame
    }

    func hideSpinner() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

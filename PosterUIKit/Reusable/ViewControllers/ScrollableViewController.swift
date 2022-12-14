//
//  ScrollableViewController.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 13.11.2022.
//

import UIKit
import PosterKit
import Combine

class ScrollableViewController<ViewModelType>: UIViewController {

    // MARK: - Properties

    var viewModel: ViewModelType

    var subsriptions: Set<AnyCancellable> = []

    // MARK: - Views

    private let scrollView = UIScrollView()

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
        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(kbdShow),
                       name: UIResponder.keyboardWillShowNotification,
                       object: nil)
        nc.addObserver(self,
                       selector: #selector(kbdHide),
                       name: UIResponder.keyboardWillHideNotification,
                       object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        let nc = NotificationCenter.default
        nc.removeObserver(self,
                          name: UIResponder.keyboardWillShowNotification,
                          object: nil)
        nc.removeObserver(self,
                          name: UIResponder.keyboardWillHideNotification,
                          object: nil)
    }

    // MARK: - Metods

    private func initialize() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        setupLayout()
    }

    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func addSubViewToScrollView(_ view: UIView) {
        scrollView.addSubview(view)
        view.snp.remakeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }

    @objc private func kbdShow(notification: NSNotification) {
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            let contentInset = UIEdgeInsets(top: 0,
                                            left: 0,
                                            bottom: kbdSize.height - (tabBarController?.tabBar.frame.height ?? 0),
                                            right: 0)

            scrollView.contentInset = contentInset
            scrollView.verticalScrollIndicatorInsets = contentInset
        }
    }

    @objc private func kbdHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

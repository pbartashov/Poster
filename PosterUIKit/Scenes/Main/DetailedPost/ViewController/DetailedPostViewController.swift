//
//  DetailedPostViewController.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 01.12.2022.
//

import UIKit
import PosterKit

final class DetailedPostViewController<T>: ScrollableViewController<T>
where T: DetailedPostViewModelProtocol {

    typealias ViewModelType = T

    // MARK: - Views

    private lazy var detailedPostView: DetailedPostView = {
        let viewFactory = ViewFactory()
        return DetailedPostView(viewFactory: viewFactory,
                                imagePickerViewDelegate: self)
    }()

    private var spinner: SpinnerViewController?

    // MARK: - LifeCicle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    // MARK: - Metods

    private func initialize() {
        super.addSubViewToScrollView(detailedPostView)
        setupEditMode()
        bindViewModel()
    }

    private func setupEditMode() {
        navigationController?.navigationBar.tintColor = .brandYellowColor
        title = "titleDetailedPostViewController".localized

        if viewModel.isEditAllowed {
            if viewModel.isNewPost {
                setSaveMode()
            } else {
                setEditMode()
            }
        }
    }

    private func setEditMode() {
        let editAction = UIAction { [self] _ in
            setSaveMode()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "editButtonDetailedPostViewController".localized,
                                                            primaryAction: editAction)
    }

    private func setSaveMode() {
        detailedPostView.isEditable = true

        let saveAction = UIAction { [self] _ in
            let content = detailedPostView.content
            let imageData = detailedPostView.image?.asImageData
            let postData = (content, imageData)
            viewModel.perfomAction(.savePost(postData))
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "saveButtonDetailedPostViewController".localized,
                                                            primaryAction: saveAction)
    }

    private func bindViewModel() {
        func bindViewModelChanges() {
            viewModel.statePublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] state in
                    state == .saving ? self?.showSpinnerView() : self?.hideSpinnerView()
                }
                .store(in: &subsriptions)

            viewModel.postViewModelPublisher
                .map { $0?.content }
                .assignOnMain(to: \.content, on: detailedPostView)
                .store(in: &subsriptions)
        }

        func bindPostViewModelChanges() {
            guard let postViewModel = viewModel.postViewModel else { return }
            let imagePublisher = postViewModel
                .$imageData
                .map { $0?.asImage }

            imagePublisher
                .assignOnMain(to: \.image, on: detailedPostView)
                .store(in: &subsriptions)

            imagePublisher
                .map { $0 == nil }
                .assignOnMain(to: \.isBusy, on: detailedPostView)
                .store(in: &subsriptions)

            postViewModel
                .$authorAvatarData
                .map { $0?.asImage ?? .avatarPlaceholder }
                .assignOnMain(to: \.authorAvatar, on: detailedPostView)
                .store(in: &subsriptions)

            postViewModel
                .$authorName
                .assignOnMain(to: \.authorName, on: detailedPostView)
                .store(in: &subsriptions)

            postViewModel
                .$authorStatus
                .assignOnMain(to: \.authorStatus, on: detailedPostView)
                .store(in: &subsriptions)
        }

        bindViewModelChanges()
        bindPostViewModelChanges()
    }

    func showSpinnerView() {
        let spinner = SpinnerViewController()
        spinner.color = .brandYellowColor
        spinner.showSpinner(for: self)

        self.spinner = spinner
    }

    func hideSpinnerView() {
        spinner?.hideSpinner()
    }
}

// MARK: - ImagePickerViewDelegate methods
extension DetailedPostViewController: ImagePickerViewDelegate {
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }

    func dismiss() {
        dismiss(animated: true)
    }
}

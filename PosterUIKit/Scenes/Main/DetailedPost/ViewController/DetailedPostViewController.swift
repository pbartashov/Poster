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

    // MARK: - Properties

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



        //        viewModel.perfomAction(.startHintTimer)
        //        viewModel.perfomAction(.autoLogin)
    }


    // MARK: - Metods

    private func initialize() {
        super.addSubView(detailedPostView)
//        title = "titleUserProfileViewController".localized
        setupEditMode()
        bindViewModel()
//        setupView()
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

//        navigationItem.rightBarButtonItem = rightBarButtonItem
//
//        navigationItem.rightBarButtonItem?.tintColor = .brandYellowColor
    }

    private func setEditMode() {
//    -> UIBarButtonItem {
        let editAction = UIAction { [self] _ in
            setSaveMode()
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "editButtonDetailedPostViewController".localized,
                        primaryAction: editAction)
    }

    private func setSaveMode() {
//    } -> UIBarButtonItem {
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
            //        detailedPostView.buttonTappedPublisher
            //            .sink { [weak self] button in
            //                guard let self = self else { return }
            //                switch button {
            //                    case .save:
            ////                        self.showImagePicker()
            //
            //                    default:
            //                        return
            //                }
            //            }
            //            .store(in: &subsriptions)


            viewModel.statePublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] state in
                    state == .saving ? self?.showSpinnerView() : self?.hideSpinnerView()
                }
//                .assignOnMain(to: \.isBusy, on: detailedPostView)
                .store(in: &subsriptions)


            viewModel.postViewModelPublisher
                .map { $0?.content }
            //            .receive(on: DispatchQueue.main)
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
                .$authorAvatar
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
//        addChild(spinner)
//        view.addSubview(spinner.view)
//        spinner.didMove(toParent: self)
//        spinner.view.frame = view.frame

        self.spinner = spinner
    }

    func hideSpinnerView() {
        spinner?.hideSpinner()
//        guard let spinner = spinner else { return }
//        spinner.willMove(toParent: nil)
//        spinner.view.removeFromSuperview()
//        spinner.removeFromParent()
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

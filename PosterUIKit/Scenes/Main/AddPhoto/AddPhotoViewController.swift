//
//  AddPhotoViewController.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 04.12.2022.
//

import UIKit
import Combine
import PosterKit

final class AddPhotoViewController<T>: UIViewController,
                                       UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate
where T: AddPhotoViewModelProtocol {

    typealias ViewModelType = T

    // MARK: - Properties

    var viewModel: ViewModelType
    var subsriptions: Set<AnyCancellable> = []



    // MARK: - Views

    private var spinner: SpinnerViewController?

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

        showImagePicker()
    }


    // MARK: - Metods

    private func initialize() {
        //        title = "titleUserProfileViewController".localized
        bindViewModel()
    }






    private func bindViewModel() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                state == .saving ? self?.showSpinnerView() : self?.hideSpinnerView()
            }
            .store(in: &subsriptions)
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

    private func showImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self

        addChild(picker)
        view.addSubview(picker.view)
        picker.didMove(toParent: self)
        picker.view.frame = view.frame
    }

    // MARK: - UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard
            let image = info[.originalImage] as? UIImage,
            let imageData = image.asImageData
        else {
            return
        }
        viewModel.perfomAction(.savePhoto(imageData: imageData))
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewModel.perfomAction(.dissmiss)
    }
}

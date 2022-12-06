//
//  AddPhotoViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 04.12.2022.
//

import Combine

public enum AddPhotoAction {
    case savePhoto(imageData: Data)
    case dissmiss
}

public enum AddPhotoState {
    case initial
    case saving
}

public protocol AddPhotoViewModelProtocol: ViewModelProtocol
where State == AddPhotoState,
      Action == AddPhotoAction {
}

public final class AddPhotoViewModel: ViewModel<AddPhotoState, AddPhotoAction>,
                                      AddPhotoViewModelProtocol {

    // MARK: - Properties

    private let photoStorage: ImageCloudStorageProtocol
    private weak var coordinator: AddPhotoCoordinatorProtocol?
    private let userService: UserServiceProtocol

    // MARK: - LifeCicle

    public init(
        userService: UserServiceProtocol,
        photoStorage: ImageCloudStorageProtocol,
        coordinator: AddPhotoCoordinatorProtocol?,
        errorPresenter: ErrorPresenterProtocol
    ) {
        self.userService = userService
        self.photoStorage = photoStorage
        self.coordinator = coordinator
        super.init(state: .initial, errorPresenter: errorPresenter)
    }

    // MARK: - Metods

    public override func perfomAction(_ action: AddPhotoAction) {
        switch action {
            case let .savePhoto(imageData):
                handleSave(imageData: imageData)

            case .dissmiss:
                coordinator?.dismissAddPhoto()
        }
    }

    private func handleSave(imageData: Data) {
        self.state = .saving
        Task {
            do {
                guard let user = userService.currentUser else { throw LoginError.userNotFound }
                let path = [user.uid]
                let fileName = UUID().uuidString
                try await photoStorage.store(imageData: imageData, withFileName: fileName, to: path)
                coordinator?.dismissAddPhoto()
            } catch {
                self.state = .initial
                errorPresenter.show(error: error)
            }
        }
    }
}

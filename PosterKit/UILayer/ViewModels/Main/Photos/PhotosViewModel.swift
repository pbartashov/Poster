//
//  PhotosViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 04.12.2022.
//

import Combine

public enum PhotosAction {
    case requestPhotos(limit: Int?)
//    case dissmiss
}

public enum PhotosState {
    case initial
//    case saving
}

public protocol PhotosViewModelProtocol: ViewModelProtocol
where State == PhotosState,
      Action == PhotosAction {

    var photos: [Data] { get }
    var photosPublisher: Published<[Data]>.Publisher { get }

    var newPhoto: Data? { get }
    var newPhotoPublisher: Published<Data?>.Publisher { get }
}

public final class PhotosViewModel: ViewModel<PhotosState, PhotosAction>,
                                    PhotosViewModelProtocol {

    // MARK: - Properties
    private let photoStorage: ImageCloudStorageProtocol
    private let userService: UserServiceProtocol

    @Published public var photos: [Data] = []
    public var photosPublisher: Published<[Data]>.Publisher {
        $photos
    }

    @Published public var newPhoto: Data?
    public var newPhotoPublisher: Published<Data?>.Publisher {
        $newPhoto
    }

    // MARK: - LifeCicle

    public init(
        photoStorage: ImageCloudStorageProtocol,
        userService: UserServiceProtocol,
        errorPresenter: ErrorPresenterProtocol
    ) {
        self.photoStorage = photoStorage
        self.userService = userService
        super.init(state: .initial, errorPresenter: errorPresenter)
    }



    // MARK: - Metods

    public override func perfomAction(_ action: PhotosAction) {
        switch action {
            case let .requestPhotos(limit):
                handlePhotosRequest(limit: limit)
        }
    }

    private func handlePhotosRequest(limit: Int?) {
        Task {
            do {
                guard let user = userService.currentUser else { throw LoginError.userNotFound }
                let path = [user.uid]
                let list = try await photoStorage.getList(in: path)
                let maxCount = limit ?? list.count

                try await withThrowingTaskGroup(of: (Data?).self) { [self] group in
                    for (i, fileName) in list.enumerated() where i < maxCount {
                        group.addTask { [self] in
                            try? await photoStorage.getImageData(withFileName: fileName, in: path)
                        }
                    }

                    for try await photoData in group {
                        guard let photoData = photoData else { continue }
                        photos.append(photoData)
                        newPhoto = photoData
                    }
                }
            } catch {
//                self.state = .initial
                errorPresenter.show(error: error)
            }
        }
    }
}


//
//  ProfileDependancyContainer.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit
import PosterKit

protocol ProfileDependancyContainerProtocol {
    func makeProfileViewModel() -> ProfileViewModel<PostsViewModel, PhotosViewModel>
    func makeProfileViewController<T, U>(viewModel: ProfileViewModel<T, U>) -> UIViewController where T: PostsViewModelProtocol, U: PhotosViewModelProtocol

//    func makePhotosViewModel() -> PhotosViewModel
    func makePhotosViewController() -> PhotosViewController<PhotosViewModel>

    func makeUserProfileViewModel() -> UserProfileViewModel
    func makeUserProfileViewController() -> UserProfileViewController

    func makeAddPhotoViewModel() -> AddPhotoViewModel
    func makeAddPhotoViewController() -> AddPhotoViewController<AddPhotoViewModel>
}


struct ProfileDependancyContainer: ProfileDependancyContainerProtocol {



    // MARK: - Properties

    private weak var profileCoordinator: (ProfileCoordinatorProtocol&UserProfileCoordinatorProtocol&AddPhotoCoordinatorProtocol)?
    private weak var postsCoordinator: PostsCoordinatorProtocol?
    private unowned var userService: UserServiceProtocol
//    private let photoStorage: ImageCloudStorageProtocol
//    private let photosViewModel: PhotosViewModel


    // MARK: - LifeCicle

    init(profileCoordinator: (ProfileCoordinatorProtocol&UserProfileCoordinatorProtocol&AddPhotoCoordinatorProtocol)?,
         postsCoordinator: PostsCoordinatorProtocol?,
         userService: UserServiceProtocol
//         photoStorage: ImageCloudStorageProtocol = ImageCloudStorage(root: PosterKit.Constants.Cloud.photosStorage,
//                                                                     fileExtension: PosterKit.Constants.Cloud.imageFileExtension)
    ) {
        self.profileCoordinator = profileCoordinator
        self.postsCoordinator = postsCoordinator
        self.userService = userService
//        self.photoStorage = photoStorage

//        func makePhotosViewModel() -> PhotosViewModel {
//            PhotosViewModel(photoStorage: photoStorage,
//                            userService: userService,
//                            errorPresenter: ErrorPresenter.shared)
//        }
//        self.photosViewModel = makePhotosViewModel()
    }

    // MARK: - Metods

    // MARK: - Profile

    func makeProfileViewModel() -> ProfileViewModel<PostsViewModel, PhotosViewModel> {


        //        let user = User(id: "5", name: userName,
        //                        avatarData: (UIImage(named: "profileImage") ?? UIImage(systemName: "person"))?.pngData(),
        //                        status: "Hardly coding")


        let contextProvider = CoreDataContextProvider.shared
        let postRepository = PostRepository(context: contextProvider.backgroundContext)
        let storageWriter = LocalStorageWriter(repository: postRepository)

        let userCloudStorage = UserCloudStorage()
        let postCloudStorage = PostCloudStorage()
        let imageCloudStorage = ImageCloudStorage(root: PosterKit.Constants.Cloud.postImagesStorage,
                                                  fileExtension: PosterKit.Constants.Cloud.imageFileExtension)

        let storageReader = CloudStorageReader(userCloudStorage: userCloudStorage,
                                               postCloudStorage: postCloudStorage,
                                               imageCloudStorage: imageCloudStorage)
        let favoritesPostsHashProvider = PostRepository(context: contextProvider.backgroundContext)
        try? favoritesPostsHashProvider.startFetchingWith(predicate: nil, sortDescriptors: nil)
        let requestFilter = Filter(authorId: userService.currentUser?.uid)

        let postsViewModel = PostsViewModel(coordinator: postsCoordinator,
                                            storageReader: storageReader,
                                            storageWriter: storageWriter,
                                            favoritesPostsHashProvider: favoritesPostsHashProvider,
                                            requestFilter: requestFilter,
                                            errorPresenter: ErrorPresenter.shared)
        let photosViewModel = makePhotosViewModel()
        
        return ProfileViewModel(//storageService: storageService,
            coordinator: profileCoordinator,
            userService: userService,
            //                                user: user,
            //postRepository: postRepository,
            postsViewModel: postsViewModel,
            photosViewModel: photosViewModel,
            errorPresenter: ErrorPresenter.shared)
    }

    func makeProfileViewController<T, U>(viewModel: ProfileViewModel<T, U>
    ) -> UIViewController where T: PostsViewModelProtocol,
                                U: PhotosViewModelProtocol {
        ProfileViewController<ProfileViewModel<T, U>, T>(viewModel: viewModel)
    }

    // MARK: - UserProfile

    func makeUserProfileViewModel() -> UserProfileViewModel {
        UserProfileViewModel(userService: userService,
                             coordinator: profileCoordinator,
                             errorPresenter: ErrorPresenter.shared)
    }

    func makeUserProfileViewController() -> UserProfileViewController {
        let viewModel = makeUserProfileViewModel()
        return UserProfileViewController(viewModel: viewModel)
    }

    // MARK: - Photos

    func makePhotosViewModel() -> PhotosViewModel {
        PhotosViewModel(photoStorage: makePhotoStorage(),
                        userService: userService,
                        errorPresenter: ErrorPresenter.shared)
    }

    func makePhotosViewController() -> PhotosViewController<PhotosViewModel> {
        let viewModel = makePhotosViewModel()
        return PhotosViewController(viewModel: viewModel)
    }

    // MARK: - AddPhotos

    func makeAddPhotoViewModel() -> AddPhotoViewModel {
        AddPhotoViewModel(userService: userService,
                          photoStorage: makePhotoStorage(),
                          coordinator: profileCoordinator,
                          errorPresenter: ErrorPresenter.shared)
    }

    func makeAddPhotoViewController() -> AddPhotoViewController<AddPhotoViewModel> {
        let viewModel = makeAddPhotoViewModel()
        return AddPhotoViewController(viewModel: viewModel)
    }

    // MARK: - Helpers
//
    func makePhotoStorage() -> ImageCloudStorage {
        ImageCloudStorage(root: PosterKit.Constants.Cloud.photosStorage,
                          fileExtension: PosterKit.Constants.Cloud.imageFileExtension)
    }
}

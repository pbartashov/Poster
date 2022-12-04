//
//  DetailedPostFactory.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 01.12.2022.
//

import UIKit
import PosterKit

struct DetailedPostFactory {

    // MARK: - Properties

    //    static var create = FavoritesFactory()

    // MARK: - Metods

    func makeDetailedPostViewModel(postViewModel: PostViewModel?,
                                   userService: UserServiceProtocol,
                                   coordinator: DetailedPostCoordinatorProtocol?,
                                   isEditAllowed: Bool
    ) -> DetailedPostViewModel {
        let postCloudStorage = PostCloudStorage()
        let imageCloudStorage = ImageCloudStorage(root: PosterKit.Constants.Cloud.postImagesStorage,
                                                  fileExtension: PosterKit.Constants.Cloud.imageFileExtension)
        let storageWriter = CloudStorageWriter(postCloudStorage: postCloudStorage,
                                               imageCloudStorage: imageCloudStorage)


        return DetailedPostViewModel(postViewModel: postViewModel,
                                     userService: userService,
                                     storageWriter: storageWriter,
                                     coordinator: coordinator,
                                     isEditAllowed: isEditAllowed,
                                     errorPresenter: ErrorPresenter.shared)
    }

    func makeDetailedPostViewController(viewModel: DetailedPostViewModel) -> DetailedPostViewController<DetailedPostViewModel> {
        DetailedPostViewController(viewModel: viewModel)
    }
}

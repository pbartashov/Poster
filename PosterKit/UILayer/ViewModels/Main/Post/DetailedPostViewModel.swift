//
//  DetailedPostViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 01.12.2022.
//

import Combine

public enum DetailedPostAction {
//    case save(post: PostViewModel)
    case savePost((content: String?, imageData: Data?))
    case dissmiss
    //    case showImagePicker
    //    case selected(post: PostViewModel)
    //    case showSignUp
    //    case showSignIn
    //    case authWith(phoneNumber: String)
    //    case signUpWith(phoneNumber: String)
    //    case comfirmPhoneNumberWith(code: String)
}

public enum DetailedPostState {
    case initial
    case saving
    //    case missingPhoneNumber
    //    case missingCode
    //    //    case wrongPhoneNumber
    //    case authFailed
    //    case processing(LoginAction)
}

public protocol DetailedPostViewModelProtocol: ViewModelProtocol
where State == DetailedPostState,
      Action == DetailedPostAction {

//    var post: PostViewModel { get }
    var isNewPost: Bool { get }
    var isEditAllowed: Bool { get }
    var postViewModel: PostViewModel? { get }
    var postViewModelPublisher: Published<PostViewModel?>.Publisher { get }
}


public final class DetailedPostViewModel: ViewModel<DetailedPostState, DetailedPostAction>,
                                          DetailedPostViewModelProtocol {


    // MARK: - Properties
//    private var storageReader: StorageReaderProtocol
    private let storageWriter: StorageWriterProtocol
    private weak var coordinator: DetailedPostCoordinatorProtocol?
    private let userService: UserServiceProtocol

    @Published public var postViewModel: PostViewModel?
    public var postViewModelPublisher: Published<PostViewModel?>.Publisher {
        $postViewModel
    }

    public var isNewPost: Bool {
        postViewModel == nil
    }

    public var isEditAllowed: Bool
//    {
//        guard
//            let postAuthorId = postViewModel?.post.authorId,
//            let currentUserUid = userService.currentUser?.uid
//        else {
//            return false
//        }
//        return postAuthorId == currentUserUid
//    }

    // MARK: - LifeCicle

    public init(postViewModel: PostViewModel?,
                userService: UserServiceProtocol,
//        storageReader: StorageReaderProtocol,
        storageWriter: StorageWriterProtocol,
        coordinator: DetailedPostCoordinatorProtocol?,
                isEditAllowed: Bool,
        errorPresenter: ErrorPresenterProtocol
    ) {
        self.postViewModel = postViewModel
        self.userService = userService
//        self.storageReader = storageReader
        self.storageWriter = storageWriter
        self.coordinator = coordinator
        self.isEditAllowed = isEditAllowed
        super.init(state: .initial, errorPresenter: errorPresenter)

//        setupViewModel()
    }



    // MARK: - Metods

    private func setupViewModel() {


        //        postsViewModel.onPostSelected = { [weak self] post in
        //            self?.postsViewModel.perfomAction(.store(post: post))
        //            //            Task { [weak self] in
        //            //                do {
        //            //                    try await self?.postsViewModel.perfomAction(.store(post: post))
        //            //                } catch {
        //            //                    self?.errorPresenter.show(error: error)
        //            //                }
        //            //            }
        //        }

        //        postsViewModel.requestPosts = { [weak self] in
        //            self?.postService.getPosts { [weak self] result in
        //                switch result {
        //                    case .success(var posts):
        //                        if var text = self?.postsViewModel.searchText {
        //                            text = text.lowercased()
        //                            posts = posts.filter { $0.author.lowercased().contains(text)}
        //                        }
        //                        self?.postsViewModel.posts = posts
        //
        //                    case .failure(let error):
        //                        self?.errorPresenter.show(error: error)
        //                }
        //            }
        //        }
    }


    public override func perfomAction(_ action: DetailedPostAction) {
        switch action {
            case let .savePost((content, imageData)):
                guard let content = content, !content.isEmpty else {
                    errorPresenter.show(error: DatabaseError.error(desription: "missingContent".localized))
                    return
                }
                handleSave(content: content, imageData: imageData)
//            case .save(let post):
//                self.state = .saving
//                Task {
//                    do {
//                        try await storageWriter.store(post: post.post)
//                        coordinator?.dismissDetailedPost()
//                    } catch {
//                        self.state = .initial
//                        errorPresenter.show(error: error)
//                    }
//                }

            case .dissmiss:
                coordinator?.dismissDetailedPost()
        }
    }

    private func handleSave(content: String, imageData: Data?) {
        self.state = .saving
        Task {
            do {
                if let post = postViewModel?.post {
                    let newPost = Post(uid: post.uid,
                                       authorId: post.authorId,
                                       content: content,
                                       likes: post.likes,
                                       views: post.views)
                    try await storageWriter.store(post: newPost,
                                                  imageData: imageData,
                                                  author: userService.currentUser)

                } else if let user = userService.currentUser {
                    try await storageWriter.createPost(author: user,
                                                       content: content,
                                                       imageData: imageData)
                } else {
                    throw LoginError.userNotFound
                }

                coordinator?.dismissDetailedPost()
            } catch {
                self.state = .initial
                errorPresenter.show(error: error)
            }
        }
    }
}

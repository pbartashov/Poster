//
//  UserProfileViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 28.11.2022.
//

import Combine

public enum UserProfileAction {
    case save(user: User)
    case dissmiss
//    case showImagePicker
//    case selected(post: PostViewModel)
    //    case showSignUp
    //    case showSignIn
    //    case authWith(phoneNumber: String)
    //    case signUpWith(phoneNumber: String)
    //    case comfirmPhoneNumberWith(code: String)
}

public enum UserProfileState {
    case initial
    case saving
    //    case missingPhoneNumber
    //    case missingCode
    //    //    case wrongPhoneNumber
    //    case authFailed
    //    case processing(LoginAction)
}

public protocol UserProfileViewModelProtocol: ViewModelProtocol
where State == UserProfileState,
      Action == UserProfileAction {

    var user: User? { get }

    var datePlaceHolderPublisher: Published<String?>.Publisher { get }
//    var postsPublisher: Published<[PostViewModel]>.Publisher { get }

    func makeDate(from text: String?) -> Date?
    func makeText(from date: Date?) -> String?
}


public final class UserProfileViewModel: ViewModel<UserProfileState, UserProfileAction>,
                                         UserProfileViewModelProtocol {


    // MARK: - Properties

    private var userService: UserServiceProtocol

    private weak var coordinator: UserProfileCoordinatorProtocol?

    public var user: User? {
        userService.currentUser
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()

        return formatter
    }()

    @Published public var datePlaceHolder: String?
    public var datePlaceHolderPublisher: Published<String?>.Publisher {
        $datePlaceHolder
    }





    // MARK: - LifeCicle

    public init(
        userService: UserServiceProtocol,
        coordinator: UserProfileCoordinatorProtocol?,
        errorPresenter: ErrorPresenterProtocol
    ) {
        self.userService = userService
        self.coordinator = coordinator
        super.init(state: .initial, errorPresenter: errorPresenter)

        setupViewModel()
    }



    // MARK: - Metods

    private func setupViewModel() {
        #warning("Check")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(localeChanged),
                                               name: NSLocale.currentLocaleDidChangeNotification,
                                               object: nil)

        setupDatePlaceHolder()

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

    private func setupDatePlaceHolder() {
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.YYYY")
        datePlaceHolder = dateFormatter.dateFormat
    }

    public override func perfomAction(_ action: UserProfileAction) {
        switch action {
            case .save(let user):
                self.state = .saving
                Task {
                    do {
                        try userService.save(user)
                        try await userService.reloadCurrentUser()
                        coordinator?.dismissUserProfile()
                    } catch {
                        self.state = .initial
                        errorPresenter.show(error: error)
                    }
                }

            case .dissmiss:
                coordinator?.dismissUserProfile()

//            case .showImagePicker:
//                coordinator?.showImagePicker()
        }
    }

    @objc func localeChanged() {
        setupDatePlaceHolder()
    }

    public func makeDate(from text: String?) -> Date? {
        if let text = text {
            return dateFormatter.date(from: text)
        } else {
            return nil
        }
    }

    public func makeText(from date: Date?) -> String? {
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

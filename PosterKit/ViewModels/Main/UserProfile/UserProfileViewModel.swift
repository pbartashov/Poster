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
}

public enum UserProfileState {
    case initial
    case saving
}

public protocol UserProfileViewModelProtocol: ViewModelProtocol
where State == UserProfileState,
      Action == UserProfileAction {

    var user: User? { get }
    var datePlaceHolderPublisher: Published<String?>.Publisher { get }

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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(localeChanged),
                                               name: NSLocale.currentLocaleDidChangeNotification,
                                               object: nil)
        setupDatePlaceHolder()
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

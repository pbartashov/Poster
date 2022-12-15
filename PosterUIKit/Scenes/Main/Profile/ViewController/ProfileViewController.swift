//
//  ProfileViewController.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 10.03.2022.
//

import UIKit
import Combine
import PosterKit

extension PostSectionType {
    static let profile = PostSectionType(rawValue: "profile")
    static let photos = PostSectionType(rawValue: "photos")
}

final class ProfileViewController<T, U>: PostsViewController<U>,
                                         UITableViewDragDelegate,
                                         UITableViewDropDelegate
where T: ProfileViewModelProtocol&DragDropProtocol,
      U == T.PostsViewModelType {

    typealias ViewModelType = T
    typealias SectionType = PostsViewController<U>.SectionType

    private enum Cell: Hashable {
        case profile(ProfileHeaderViewCell)
        case photos(PhotosTableViewCell)
        case post(PostViewModel)
    }

    // MARK: - Properties

    private var subscriptions: Set<AnyCancellable> = []

    private var profileViewModel: ViewModelType

    private var avatarPresenter: AvatarPresenter?

    private lazy var cellsDataSource: UITableViewDiffableDataSource<SectionType, Cell> = {
        let tableViewDataSource = UITableViewDiffableDataSource<SectionType, Cell>(
            tableView: tableView,
            cellProvider: { [weak self] (tableView, indexPath, cell) -> UITableViewCell? in
                guard let self = self else { return nil }

                switch cell {
                    case .profile(let profileCell):
                        return profileCell

                    case .photos(let photosCell):
                        return photosCell

                    case .post(let post):
                        return self.getPostCell(indexPath: indexPath, post: post)
                }
            })

        return tableViewDataSource
    }()

    private var cellsSnapshot: NSDiffableDataSourceSnapshot<SectionType, Cell> {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Cell>()
        snapshot.appendSections([.profile, .photos])
        snapshot.appendItems([.profile(profileHeaderView)], toSection: .profile)
        snapshot.appendItems([.photos(photosTableViewCell)], toSection: .photos)

        let cells = postItems.map { Cell.post($0) }
        snapshot.appendSections(postSections)
        snapshot.appendItems(cells, toSection: .posts)

        return snapshot
    }

    // MARK: - Views

    private lazy var profileHeaderView: ProfileHeaderViewCell = {
        let profileHeaderView = ProfileHeaderViewCell()
        profileHeaderView.delegate = self

        return profileHeaderView
    }()

    private lazy var photosTableViewCell = PhotosTableViewCell()

    // MARK: - LifeCicle

    init(viewModel: ViewModelType) {
        self.profileViewModel = viewModel
        super.init(viewModel: profileViewModel.postsViewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

//    override func viewSafeAreaInsetsDidChange() {
//        if isAvatarPresenting {
//            moveAndScaleAvatarToCenter()
//        }
//    }

    // MARK: - Metods

    private func initialize() {
//        tableView.dragDelegate = self
//        tableView.dropDelegate = self
//        tableView.dragInteractionEnabled = true
        postsSectionNumber = 2

        navigationController?.navigationBar.tintColor = .brandYellowColor

        bindViewModel()
    }

    private func bindViewModel() {
        profileViewModel.photosPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photosData in
                let photos = photosData.compactMap { $0.asImage }
                self?.photosTableViewCell.setup(with: photos)
            }
            .store(in: &subscriptions)

        profileViewModel.userPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.profileHeaderView.setup(with: $0)

            }
            .store(in: &subscriptions)
    }

    override func applySnapshot() {
        cellsDataSource.apply(cellsSnapshot)
    }

    override func fetchData() {
        super.fetchData()
        profileViewModel.perfomAction(.requstPhotos)
    }

    // MARK: - UITableViewDelegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)

        if indexPath == IndexPath(row: 0, section: 1) {
            profileViewModel.perfomAction(.showPhotos)
        }
    }

    // MARK: - UITableViewDragDelegate methods
    func tableView(_ tableView: UITableView,
                   itemsForBeginning session: UIDragSession,
                   at indexPath: IndexPath
    ) -> [UIDragItem] {
        profileViewModel.dragItems(for: indexPath)
    }

    // MARK: - UITableViewDropDelegate methods
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        profileViewModel.canHandle(session)
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        profileViewModel.handle(dropSessionDidUpdate: session, withDestinationIndexPath: destinationIndexPath)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        profileViewModel.handle(performDropWith: coordinator) { [weak self] in
            self?.applySnapshot()
        }
    }
}

// MARK: - ProfileHeaderViewDelegate methods
extension ProfileViewController: ProfileHeaderViewDelegate {
    func editUserProfileButtonTapped() {
        profileViewModel.perfomAction(.showUserProfile)
    }

    func avatarTapped(sender: UIImageView) {
        avatarPresenter = AvatarPresenter()
        avatarPresenter?.present(sender, on: self)
    }

    func addPostButtonTapped() {
        profileViewModel.perfomAction(.showAddPost)
    }

    func addStoryButtonTapped() {
        profileViewModel.perfomAction(.showAddStory)
    }

    func addPhotoButtonTapped() {
        profileViewModel.perfomAction(.showAddPhoto)
    }
}

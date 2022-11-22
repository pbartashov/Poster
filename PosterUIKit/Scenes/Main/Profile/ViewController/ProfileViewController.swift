//
//  ProfileViewController.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 10.03.2022.
//

import UIKit
import PosterKit

extension PostSectionType {
    static let profile = PostSectionType(rawValue: "profile")
    static let photos = PostSectionType(rawValue: "photos")
}

final class ProfileViewController<T, U>: PostsViewController<U>,
                                         UITableViewDelegate,
                                         UITableViewDragDelegate,
                                         UITableViewDropDelegate
where T: ProfileViewModelProtocol&DragDropProtocol,
      U == T.PostsViewModelType {

    typealias ViewModelType = T
    typealias SectionType = PostsViewController<U>.SectionType

    private enum Cell: Hashable {
        case profile(ProfileHeaderViewCell)
        case photos(PhotosTableViewCell)
        case post(Post)
    }

    //MARK: - Properties

    private var profileViewModel: ViewModelType

    private var isAvatarPresenting: Bool = false {
        didSet {
            tableView.isUserInteractionEnabled = !isAvatarPresenting
        }
    }

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
        postsSectionNumber = 2

        return snapshot
    }

    //MARK: - Views

    private weak var avatar: UIView?
    private weak var coverView: UIView?
    private weak var closeAvatarPresentationButton: UIButton?

    private lazy var profileHeaderView: ProfileHeaderViewCell = {
        let profileHeaderView = ProfileHeaderViewCell()
        profileHeaderView.delegate = self
        profileHeaderView.setup(with: profileViewModel.user)

        return profileHeaderView
    }()

    private lazy var photosTableViewCell = PhotosTableViewCell()

    //MARK: - LifeCicle

    init(viewModel: ViewModelType) {
        self.profileViewModel = viewModel
        super.init(viewModel: profileViewModel.postsViewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        let photos = Photos.randomPhotos(ofCount: photosTableViewCell.photosCount)
//        photosTableViewCell.setup(with: photos)
    }

    override func viewSafeAreaInsetsDidChange() {
        if isAvatarPresenting {
            moveAndScaleAvatarToCenter()
        }
    }

    //MARK: - Metods

    override func applySnapshot() {
        cellsDataSource.apply(cellsSnapshot)
    }

    private func moveAndScaleAvatarToCenter() {
        guard let avatar = avatar else {
            return
        }

        let layoutFrame = view.safeAreaLayoutGuide.layoutFrame
        let scale = min(layoutFrame.size.width, layoutFrame.size.height) / avatar.bounds.width

        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        let translateTransform = CGAffineTransform(translationX: layoutFrame.midX - avatar.center.x,
                                                   y: layoutFrame.midY - avatar.center.y)

        avatar.transform = scaleTransform.concatenating(translateTransform)
    }

    private func createCover() {
        let cover = UIView()
        cover.backgroundColor = .lightBackgroundColor
        cover.alpha = 0.0

        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "xmark", withConfiguration: configuration)
        let action = UIAction(image: image) { [weak self] _ in
            self?.closeAvatarPresentation()
        }

        let button = UIButton(frame: .zero, primaryAction: action)
        button.tintColor = .textColor
        button.alpha = 0.0

        view.addSubview(button)
        profileHeaderView.addSubview(cover)

        cover.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.UI.padding)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-Constants.UI.padding)
        }

        self.coverView = cover
        self.closeAvatarPresentationButton = button
    }

    private func closeAvatarPresentation() {
        let duration = 0.8

        UIView.animateKeyframes(withDuration: duration, delay: 0.0,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: 0.3 / duration) {

                self.closeAvatarPresentationButton?.alpha = 0.0
            }

            UIView.addKeyframe(withRelativeStartTime: 0.3 / duration,
                               relativeDuration: 0.5 / duration ) { [weak self] in
                guard let self = self, let avatar = self.avatar else { return }

                self.coverView?.alpha = 0.0
                avatar.transform = .identity
                avatar.layer.cornerRadius = avatar.bounds.width / 2
            }
        }, completion: { [self] _ in
            coverView?.removeFromSuperview()
            closeAvatarPresentationButton?.removeFromSuperview()
            avatar = nil
            isAvatarPresenting = false
        }
        )
    }

    // MARK: - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

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
    func statusButtonTapped() {
//        profileViewModel.user?.status = profileHeaderView.statusText
        profileHeaderView.setup(with: profileViewModel.user)
    }

    func avatarTapped(sender: UIView) {
        isAvatarPresenting = true

        createCover()

        avatar = sender
        profileHeaderView.bringSubviewToFront(sender)

        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.coverView?.alpha = 0.5
            self?.avatar?.layer.cornerRadius = 0
            self?.moveAndScaleAvatarToCenter()
        } completion: { _ in
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.closeAvatarPresentationButton?.alpha = 1
            }
        }
    }
}
//
//  PostsViewController.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 15.11.2022.
//


import UIKit
import Combine
import PosterKit
import iOSIntPackage

struct PostSectionType: RawRepresentable, Hashable {
    let rawValue: String
}

extension PostSectionType {
    static let posts = PostSectionType(rawValue: "posts")
}

class PostsViewController<ViewModelType: PostsViewModelProtocol>: UIViewController,
                                                                  UITableViewDelegate {

    typealias SectionType = PostSectionType

    // MARK: - Properties

    private(set) var viewModel: ViewModelType
//    private var postViewModelProvider: PostViewModelProvider

    private var subscriptions: Set<AnyCancellable> = []

    var postsSectionNumber = 0
    private var currentColorFilter: ColorFilter? {
        didSet {
            for (i, postViewModel) in viewModel.posts.enumerated() {
                let indexPath = IndexPath(row: i, section: postsSectionNumber)
                if let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell {
//                    let postViewModel = postViewModelProvider.makeViewModel(for: post)
                    cell.setup(with: postViewModel, filter: currentColorFilter)
                }
            }
        }
    }

    private lazy var postsDataSource: UITableViewDiffableDataSource<PostSectionType, PostViewModel> = {
        let tableViewDataSource = UITableViewDiffableDataSource<PostSectionType, PostViewModel>(
            tableView: tableView,
            cellProvider: { [weak self] (tableView, indexPath, post) -> UITableViewCell? in
                return self?.getPostCell(indexPath: indexPath, post: post)
            })

        return tableViewDataSource
    }()

    private var postsSnapshot: NSDiffableDataSourceSnapshot<PostSectionType, PostViewModel> {
        var snapshot = NSDiffableDataSourceSnapshot<PostSectionType, PostViewModel>()
        snapshot.appendSections(postSections)
        snapshot.appendItems(postItems)

        return snapshot
    }

    var postSections: [PostSectionType] {
        [PostSectionType.posts]
    }

    var postItems: [PostViewModel] {
        viewModel.posts
    }

    // MARK: - Views

    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.register(PostTableViewCell.self,
                           forCellReuseIdentifier: PostTableViewCell.identifier)

        tableView.backgroundColor = .brandBackgroundColor
        tableView.delegate = self
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
//        doubleTap.numberOfTapsRequired = 2
//        tableView.addGestureRecognizer(doubleTap)

        return tableView
    }()

    private lazy var colorFilterSelector: UISegmentedControl = {
        let off = UIAction(title: "offColorFilterPostsViewController".localized) { _ in
            self.currentColorFilter = nil
        }

        let noir = UIAction(title: "noirColorFilterPostsViewController".localized) { _ in
            self.currentColorFilter = .noir
        }

        let motionBlur = UIAction(title: "motionBlurColorFilterPostsViewController".localized) { _ in
            self.currentColorFilter = .motionBlur(radius: 10)
        }

        let invert = UIAction(title: "invertColorFilterPostsViewController".localized) { _ in
            self.currentColorFilter = .colorInvert
        }

        let control = UISegmentedControl(items: [off,
                                                 noir,
                                                 motionBlur,
                                                 invert])
        control.selectedSegmentIndex = 0

        return control
    }()

    private var cancelSearchBarItem: UIBarButtonItem?

    // MARK: - LifeCicle

    init(viewModel: ViewModelType
//         postViewModelProvider: PostViewModelProvider
    ) {
        self.viewModel = viewModel
//        self.postViewModelProvider = postViewModelProvider

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brandBackgroundColor

        view.addSubview(colorFilterSelector)
        view.addSubview(tableView)

        setupLayout()
        configureRefreshControl()
        bindViewModel()
        setupBarItems()

        fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applySnapshot()
    }

    // MARK: - Metods

    private func bindViewModel() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                    case .initial:
                        break

                    case .postsLoaded:
                        if self.view.window != nil {
                            self.tableView.refreshControl?.endRefreshing()
                            self.applySnapshot()
                        }

                    case .isFiltered(let text):
                        if let text = text {
                            self.cancelSearchBarItem?.isEnabled = true
                            self.navigationItem.title = "\("foundedResultsPostsViewController".localized): \(text)"
                        } else {
                            self.cancelSearchBarItem?.isEnabled = false
                            self.navigationItem.title = nil
                        }
                }
            }
            .store(in: &subscriptions)
    }

    private func setupLayout() {
        colorFilterSelector.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(colorFilterSelector.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupBarItems() {
        let searchAction = UIAction { [weak self] _ in
            self?.viewModel.perfomAction(.showSearchPromt)
        }

        let searchItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                         primaryAction: searchAction)

        let clearAction = UIAction { [weak self] _ in
            self?.viewModel.perfomAction(.cancelSearch)
        }

        let cancelSearchItem = UIBarButtonItem(image: UIImage(systemName: "return"),
                                               primaryAction: clearAction)
        cancelSearchItem.isEnabled = false

        navigationItem.setRightBarButtonItems([cancelSearchItem, searchItem], animated: false)
        cancelSearchBarItem = cancelSearchItem
    }

    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                                 action: #selector(handleRefreshControl),
                                                 for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        fetchData()
    }

    func fetchData() {
        viewModel.perfomAction(.requstPosts)
    }

    func getPostCell(indexPath: IndexPath, post: PostViewModel) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,
                                                       for: indexPath)
                as? PostTableViewCell
        else {
            return UITableViewCell()
        }

//        let postViewModel = postViewModelProvider.makeViewModel(for: post)

        cell.setup(with: post,
                   filter: self.currentColorFilter)
        return cell
    }

    func applySnapshot() {
        postsDataSource.apply(postsSnapshot)
    }

//    @objc func handleDoubleTap(recognizer: UIGestureRecognizer) {
//        let tappedPoint = recognizer.location(in: tableView)
//
//        if let indexPath = tableView.indexPathForRow(at: tappedPoint) {
//            tableView.deselectRow(at: indexPath, animated: true)
//
//            let post = viewModel.posts[indexPath.row]
//            viewModel.perfomAction(.selected(post: post))
//        }
//    }

// MARK: - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == postsSectionNumber {
            let post = viewModel.posts[indexPath.row]
            viewModel.perfomAction(.selected(post: post))
        }
    }
}

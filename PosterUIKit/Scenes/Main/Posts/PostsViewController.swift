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

    private var subscriptions: Set<AnyCancellable> = []

    var postsSectionNumber = 0
    
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
        tableView.backgroundColor = .brandBackgroundColor
        tableView.delegate = self
        tableView.register(PostTableViewCell.self,
                           forCellReuseIdentifier: PostTableViewCell.identifier)
        return tableView
    }()

    private var cancelSearchBarItem: UIBarButtonItem?

    // MARK: - LifeCicle

    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brandBackgroundColor
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
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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
        viewModel.perfomAction(.requstPosts(filteredBy: nil))
    }

    func getPostCell(indexPath: IndexPath, post: PostViewModel) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,
                                                       for: indexPath)
                as? PostTableViewCell
        else {
            return UITableViewCell()
        }

        cell.setup(with: post) { [weak self] in
            self?.viewModel.perfomAction(.addToFavorites(post: post))
        }
        
        return cell
    }
    
    func applySnapshot() {
        postsDataSource.apply(postsSnapshot)
    }

    // MARK: - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == postsSectionNumber {
            let post = viewModel.posts[indexPath.row]
            viewModel.perfomAction(.selected(post: post))
        }
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        return nil
    }
}

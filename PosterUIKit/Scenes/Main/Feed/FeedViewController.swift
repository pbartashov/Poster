//
//  FeedViewController.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 06.03.2022.
//


import UIKit
import PosterKit
import Combine

fileprivate enum FeedSupplementaryViewKind {
    static let storiesHeader = "story"
    static let postsHeader = "post"
}

final class FeedViewController<ViewModelType: FeedViewModelProtocol>: UICollectionViewController {

    // MARK: Section Definitions

    enum Section: Hashable {
        case storiesSection
        case postsSection
    }

    enum FeedCollectionItem: Hashable {
        case storyItem(StoryViewModel)
        case postItem(PostViewModel)
    }

    // MARK: - Properties

    private let viewModel: ViewModelType

    private var subscriptions: Set<AnyCancellable> = []
    private var isRecommendedSubscription: AnyCancellable?

    private var dataSource: UICollectionViewDiffableDataSource<Section, FeedCollectionItem>!
    private var sections = [Section]()

    @Published private var storiesItems: [FeedCollectionItem]?
    @Published private var postsItems: [FeedCollectionItem]?
    private var isRecommended: Bool = false

    // MARK: - LifeCicle

    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        configureCollectionView()
        view = collectionView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .brandYellowColor
        applySnapshot()
        bindViewModelToViews()
        fetchData()
    }

    // MARK: - Metods

    private func fetchData() {
        beginRefreshing()
        if isRecommended {
            viewModel.perfomAction(.requestRecommendedPosts)
        } else {
            viewModel.perfomAction(.requestData)
        }
    }

    private func beginRefreshing() {
        guard
            let refreshControl = collectionView.refreshControl,
            !refreshControl.isRefreshing
        else {
            return
        }
        let offsetY = collectionView.contentOffset.y - refreshControl.bounds.size.height
        self.collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
        collectionView.refreshControl?.beginRefreshing()
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

        collectionView.register(StoriesViewCell.self,
                                forCellWithReuseIdentifier: StoriesViewCell.identifier)

        collectionView.register(PostCollectionViewCell.self,
                                forCellWithReuseIdentifier: PostCollectionViewCell.identifier)

        collectionView.register(StoriesSectionHeaderView.self,
                                forSupplementaryViewOfKind: FeedSupplementaryViewKind.storiesHeader,
                                withReuseIdentifier: StoriesSectionHeaderView.identifier)

        collectionView.register(PostsSectionHeaderView.self,
                                forSupplementaryViewOfKind: FeedSupplementaryViewKind.postsHeader,
                                withReuseIdentifier: PostsSectionHeaderView.identifier)
        collectionView.delegate = self

        configureDataSource()
        configureRefreshControl()
    }

    private func configureRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self,
                                                 action: #selector(handleRefreshControl),
                                                 for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        fetchData()
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard !self.sections.isEmpty else { return nil }

            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(44))
            let storiesHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: FeedSupplementaryViewKind.storiesHeader,
                alignment: .topTrailing
            )

            let postsHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: FeedSupplementaryViewKind.postsHeader,
                alignment: .topTrailing
            )

            let section = self.sections[sectionIndex]
            switch section {
                case .storiesSection:
                    // MARK: Stories Section Layout
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                          heightDimension: .fractionalHeight(1))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.UI.interStoriesSpace / 2,
                                                                 bottom: 0, trailing: Constants.UI.interStoriesSpace / 2)

                    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(Constants.UI.storiesImageSize + Constants.UI.interStoriesSpace),
                                                           heightDimension: .estimated(Constants.UI.storiesImageSize))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                   subitems: [item])

                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous
                    section.boundarySupplementaryItems = [storiesHeaderItem]
                    section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0,
                                                                    bottom: 32, trailing: 0)
                    return section

                case .postsSection:
                    // MARK: Posts Section Layout
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                          heightDimension: .estimated(500))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .estimated(500))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                   subitems: [item])

                    let section = NSCollectionLayoutSection(group: group)
                    section.boundarySupplementaryItems = [postsHeaderItem]

                    return section
            }
        }

        return layout
    }

    private func configureDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { [weak self]
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let section = self.sections[indexPath.section]
            switch section {
                case .storiesSection:
                    guard
                        let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: StoriesViewCell.identifier,
                            for: indexPath
                        ) as? StoriesViewCell,
                        case .storyItem(let story) = self.storiesItems?[indexPath.item]
                    else {
                        return nil
                    }
                    cell.setup(with: story)

                    return cell

                case .postsSection:
                    guard
                        let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: PostCollectionViewCell.identifier,
                            for: indexPath
                        ) as? PostCollectionViewCell,
                        case .postItem(let post) = self.postsItems?[indexPath.item]
                    else {
                        return nil
                    }
                    cell.setup(with: post) {
                        self.viewModel.perfomAction(.addToFavorites(post: post))
                    }

                    return cell
            }
        })

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            guard let self = self else { return nil }
            switch kind {
                case FeedSupplementaryViewKind.storiesHeader:
                    guard
                        let headerView = collectionView.dequeueReusableSupplementaryView(
                            ofKind: FeedSupplementaryViewKind.storiesHeader,
                            withReuseIdentifier: StoriesSectionHeaderView.identifier,
                            for: indexPath
                        ) as? StoriesSectionHeaderView
                    else {
                        return nil
                    }
                    self.isRecommendedSubscription = headerView
                        .$isRecommended
                        .sink {
                            self.isRecommended = $0
                            self.fetchData()
                        }

                    return headerView

                case FeedSupplementaryViewKind.postsHeader:
                    guard
                        let headerView = collectionView.dequeueReusableSupplementaryView(
                            ofKind: FeedSupplementaryViewKind.postsHeader,
                            withReuseIdentifier: PostsSectionHeaderView.identifier,
                            for: indexPath
                        ) as? PostsSectionHeaderView
                    else {
                        return nil
                    }
//                    headerView.setup(labelTitle: "", buttonTitle: "")

                    return headerView

                default:
                    return nil
            }
        }
    }

    private func bindViewModelToViews() {
        func bindViewModelToSections() {
            viewModel.storiesPublisher
                .removeDuplicates()
                .map { stories in
                    stories.map {
                        FeedCollectionItem.storyItem($0)
                    }
                }
                .assign(to: &$storiesItems)

            viewModel.postsPublisher
                .removeDuplicates()
                .map { posts in
                    posts.map {
                        FeedCollectionItem.postItem($0)
                    }
                }
                .assign(to: &$postsItems)
        }

        func bindToCollectionView() {
            Publishers.MergeMany(
                viewModel.storiesPublisher.eraseType(),
                viewModel.postsPublisher.eraseType()
            )
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.refreshControl?.endRefreshing()
                self?.applySnapshot()
            }
            .store(in: &subscriptions)
        }

        bindViewModelToSections()
        bindToCollectionView()
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FeedCollectionItem>()
        if let storiesItem = storiesItems {
            snapshot.appendSections([.storiesSection])
            snapshot.appendItems(storiesItem, toSection: .storiesSection)
        }

        if let postsItems = postsItems {
            snapshot.appendSections([.postsSection])
            snapshot.appendItems(postsItems, toSection: .postsSection)
        }

        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }

    private func showDetailedPost(at indexPath: IndexPath) {
        if let item = postsItems?[indexPath.item],
           case let .postItem(post) = item {
            viewModel.perfomAction(.selected(post: post))
        }
    }

    // MARK: UICollectionViewDelegate
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch indexPath.section {
            case 1:
                showDetailedPost(at: indexPath)

            default:
                break
        }
    }
}

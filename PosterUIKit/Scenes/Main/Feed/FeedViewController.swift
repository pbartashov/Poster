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
//        case loading
        case storiesSection
        case postsSection//([Post])
    }


    enum FeedCollectionItem: Hashable {
        case storyItem(Story)
        case postItem(PostViewModel)
    }


    // MARK: - Properties

    private let viewModel: ViewModelType
//    private let postViewModelProvider: PostViewModelProvider

    private var subscriptions: Set<AnyCancellable> = []
//    private var presentPostSubscription: AnyCancellable?


    private var dataSource: UICollectionViewDiffableDataSource<Section, FeedCollectionItem>!
    private var sections = [Section]()

    @Published private var storiesItems: [FeedCollectionItem]?
    @Published private var postsItems: [FeedCollectionItem]?

    // Factories
    //    private let hourlyWeatherViewControllerFactory: HourlyWeatherViewControllerFactory
    //    private let dailyWeatherViewControllerFactory: DailyWeatherViewControllerFactory

    // MARK: - LifeCicle

    init(viewModel: ViewModelType
//         postViewModelProvider: PostViewModelProvider
         //         dailyWeatherViewControllerFactory: DailyWeatherViewControllerFactory
    ) {
        self.viewModel = viewModel
//        self.postViewModelProvider = postViewModelProvider
        //        self.hourlyWeatherViewControllerFactory = hourlyWeatherViewControllerFactory
        //        self.dailyWeatherViewControllerFactory = dailyWeatherViewControllerFactory

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

        applySnapshot()
        bindViewModelToViews()
        fetchData()
    }

    //    public override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        navigationController?.navigationBar.titleTextAttributes = [
    //            NSAttributedString.Key.foregroundColor: UIColor.brandTextColor,
    //            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)
    //        ]
    //    }

    // MARK: - Metods

    private func fetchData() {
        viewModel.perfomAction(.requestData)
//        Task {
//            await viewModel.fetchWeathers()
//        }
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

        //        collectionView.register(LoadingCell.self,
        //                                forCellWithReuseIdentifier: LoadingCell.identifier)

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

//        collectionView.contentInsetAdjustmentBehavior = .never
//        collectionView.contentInset = .init(top: 0, left: 0, bottom: 160, right: 0)

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

//            let widthFactor = layoutEnvironment.traitCollection.horizontalSizeClass == .compact ? 1.0 : 0.6

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
//                case .loading:
//                    // MARK: Loading Section Layout
//                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                                          heightDimension: .fractionalHeight(1))
//
//                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92),
//                                                           heightDimension: .estimated(212))
//                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                                   subitems: [item])
//
//                    let section = NSCollectionLayoutSection(group: group)
//                    section.orthogonalScrollingBehavior = .groupPagingCentered
//                    section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0,
//                                                                    bottom: 28, trailing: 0)
//                    return section

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
//                    item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0,
//                                                                 bottom: 8, trailing: 0)

//                    let safeAreaInsets = self.collectionView.safeAreaInsets
//                    let safeAreaSides = safeAreaInsets.left + safeAreaInsets.right
//                    let contentWidth = layoutEnvironment.container.contentSize.width
//                    let groupWidth = contentWidth * widthFactor - Constants.UI.padding * 2 - safeAreaSides
//                    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(groupWidth),
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .estimated(500))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                 subitems: [item])

                    let section = NSCollectionLayoutSection(group: group)
//                    let sectionSideInset = (contentWidth - groupWidth) / 2
//                    section.contentInsets = NSDirectionalEdgeInsets(top: 0,
//                                                                    leading: sectionSideInset,
//                                                                    bottom: 0,
//                                                                    trailing: sectionSideInset)

//                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.UI.padding,
//                                                                    bottom: 0, trailing: Constants.UI.padding)
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
//                case .loading:
//                    return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.identifier,
//                                                              for: indexPath)

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
//                    let postViewModel = self.postViewModelProvider.makeViewModel(for: post)
                    cell.setup(with: post)

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

                    headerView.setup(buttonTitle: "Подробнее на 24 часа")
//                    self.presentHourlyWeatherSubscription = headerView
//                        .buttonTappedPublisher
//                        .eraseType()
//                        .sink {[weak self] in
//                            self?.presentHourlyWeather()
//                        }

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

//                    let publisher = headerView.buttonTappedPublisher.eraseType()
//                    self.viewModel.subscribeToggleForecastHorizon(to: publisher)
//
//                    let buttonTitle = "\(self.viewModel.toggleForecastHorizonTitle) дней"
                    headerView.setup(labelTitle: "Ежедневный прогноз", buttonTitle: "buttonTitle")

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
                $storiesItems.eraseTypeAndDuplicates(),
                $postsItems.eraseTypeAndDuplicates()
            )
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
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

//        if let currentWeatherItem = currentWeatherItem,
//           case .currentWeatherItem(let weather) = currentWeatherItem {
//            snapshot.appendSections([.currentWeatherSection])
//
//            let item = FeedCollectionItem.currentWeatherItem(weather)
//            snapshot.appendItems([item], toSection: .currentWeatherSection)
//        } else {
//            snapshot.appendSections([.loading])
//            snapshot.appendItems([FeedCollectionItem.empty(UUID())], toSection: .loading)
//        }
//

        if let storiesItem = storiesItems {
            snapshot.appendSections([.storiesSection])

            snapshot.appendItems(storiesItem, toSection: .storiesSection)
        }

        if let postsItems = postsItems {
            snapshot.appendSections([.postsSection])

            snapshot.appendItems(postsItems, toSection: .postsSection)
        }

//        if let dailyWeatherSection = dailyWeatherSection,
//           case .dailyWeatherSection(let weathers) = dailyWeatherSection {
//            snapshot.appendSections([dailyWeatherSection])
//
//            let items = weathers.map { FeedCollectionItem.dailyWeatherItem($0) }
//            snapshot.appendItems(items, toSection: dailyWeatherSection)
//        }

        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }

    private func presentHourlyWeather() {
//        let hourlyWeatherPublisher = viewModel.$hourlyWeather.eraseToAnyPublisher()
//        let hourlyViewController = hourlyWeatherViewControllerFactory
//            .makeHourlyWeatherViewController(for: viewModel.location.cityName,
//                                             weathers: hourlyWeatherPublisher)
//        navigationController?.pushViewController(hourlyViewController, animated: true)
    }

    private func presentDailyWeather() {
//        let dailyWeatherPublisher = viewModel.$dailyWeather.eraseToAnyPublisher()
//        let dailyViewController = dailyWeatherViewControllerFactory
//            .makeDailyWeatherViewController(for: viewModel.location,
//                                            weathers: dailyWeatherPublisher)
//        navigationController?.pushViewController(dailyViewController, animated: true)
    }

    // MARK: UICollectionViewDelegate
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            case 1:
                presentHourlyWeather()

            case 2:
                presentDailyWeather()

            default:
                break
        }
    }
}

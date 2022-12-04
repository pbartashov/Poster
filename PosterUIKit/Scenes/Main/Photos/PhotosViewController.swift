//
//  PhotosViewController.swift
//  PosterKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import UIKit
import Combine
import PosterKit

final class PhotosViewController<T>: UIViewController,
                                     UICollectionViewDataSource,
                                     UICollectionViewDelegateFlowLayout
    where T: PhotosViewModelProtocol {

    typealias ViewModelType = T

    // MARK: - Properties

    private var subscriptions: Set<AnyCancellable> = []
    private let viewModel: ViewModelType
    private var itemsPerRow: CGFloat { 3 }
    private var spacing: CGFloat { 8 }

    // MARK: - Views

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewLayout)

        collectionView.register(PhotosCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .brandBackgroundColor

        return collectionView
    }()

    // MARK: - LifeCicle

    init(viewModel: ViewModelType
         //         postViewModelProvider: PostViewModelProvider
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()

        viewModel.perfomAction(.requestPhotos(limit: nil))
    }

    // MARK: - Metods

    private func initialize() {
        title = "titlePhotosViewController".localized
        view.backgroundColor = .brandBackgroundColor

        view.addSubview(collectionView)
        setupLayout()
        bindViewModel()
    }

    private func setupLayout() {
        collectionView.makeEdgesConstraintsEqualToSuperview()
    }

    // MARK: - UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier,
                                                      for: indexPath)
                as? PhotosCollectionViewCell,
            let photo = viewModel.photos[indexPath.row].asImage
        else {
            return UICollectionViewCell()
        }
        cell.setup(with: photo)

        return cell
    }

    private func bindViewModel() {
        viewModel.newPhotoPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.performBatchUpdates {
                    let indexPath = IndexPath(item: self.viewModel.photos.count - 1, section: 0)
                    self.collectionView.insertItems(at: [indexPath])
                }
            }
            .store(in: &subscriptions)
    }


// MARK: - UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingSpace = spacing * (itemsPerRow + 1)
        let availableWidth = view.safeAreaLayoutGuide.layoutFrame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        spacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int)
    -> CGFloat {
        spacing
    }
}

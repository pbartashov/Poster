////
////  CoverView.swift
////  PosterUIKit
////
////  Created by Павел Барташов on 11.12.2022.
////
//
//import UIKit
//
//protocol CoverViewDelegate: AnyObject {
//    func closeAvatarPresentation()
//}
//
//class CoverView: UIView {
//
//    // MARK: - Properties
//
//    private weak var delegate: CoverViewDelegate?
//    
//    // MARK: - Views
//
//    private lazy var closeButton: UIButton = {
//        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
//        let image = UIImage(systemName: "xmark", withConfiguration: configuration)
//        let action = UIAction(image: image) { [weak self] _ in
//            self?.delegate?.closeAvatarPresentation()
//        }
//
//        let button = UIButton(frame: .zero, primaryAction: action)
//        button.tintColor = .brandTextBlackColor
//        button.alpha = 0.0
//
//        return button
//    }()
//
//    private lazy var imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//
//        return imageView
//    }()
//
//    // MARK: - LifeCicle
//
//    init(delegate: CoverViewDelegate?) {
//        self.delegate = delegate
//        super.init(frame: .zero)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Metods
//
//    private func initialize() {
//        backgroundColor = .brandLightBackgroundColor
//        alpha = 0.0
//
//        [imageView,
//         closeButton
//        ].forEach {
//            addSubview($0)
//        }
//
//        setupLayouts()
//    }
//
//    private func setupLayouts() {
//
//
//    }
//
//
//}
//

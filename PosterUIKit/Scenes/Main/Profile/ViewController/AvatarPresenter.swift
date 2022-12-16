//
//  AvatarPresenter.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 11.12.2022.
//

import UIKit
import PosterKit

final class AvatarPresenter: UIViewController {

    // MARK: - Properties

    private var onClose: (() -> Void)?

    // MARK: - Views

    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandLightBackgroundColor
        view.alpha = 0.0

        return view
    }()

    private lazy var closeButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "xmark", withConfiguration: configuration)
        let action = UIAction(image: image) { [weak self] _ in
            self?.close()
        }

        let button = UIButton(frame: .zero, primaryAction: action)
        button.tintColor = .brandTextBlackColor
        button.alpha = 0.0

        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    // MARK: - LifeCicle

    init() {
        super.init(nibName: nil, bundle: nil)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
    }

    private func addObservers() {
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(rotated),
                         name: UIDevice.orientationDidChangeNotification,
                         object: nil)
    }

    @objc func rotated() {
        DispatchQueue.main.async {
            self.remakeImageConstraints()
        }
    }

    // MARK: - Metods

    private func initialize() {
        [coverView,
         imageView,
         closeButton
        ].forEach {
            view.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        coverView.makeEdgesConstraintsEqualToSuperview()

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.UI.padding)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-Constants.UI.padding)
        }
    }

    private func remakeImageConstraints() {
        guard
            let imageAspectRatio = imageView.image?.aspectRatio,
            imageAspectRatio > 0
        else {
            imageView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
            return
        }

        let layoutFrame = view.safeAreaLayoutGuide.layoutFrame
        let viewAspectRatio = layoutFrame.height / layoutFrame.width

        imageView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            if imageAspectRatio < viewAspectRatio {
                make.width.equalTo(view.safeAreaLayoutGuide)
                make.height.equalTo(imageView.snp.width).multipliedBy(imageAspectRatio)
            } else {
                make.height.equalTo(view.safeAreaLayoutGuide)
                make.width.equalTo(imageView.snp.height).dividedBy(imageAspectRatio)
            }
        }
    }

    func present(_ avatar: UIImageView, on presenter: UIViewController) {
        imageView.image = avatar.image

        presenter.addChild(self)
        presenter.view.addSubview(view)
        didMove(toParent: presenter)
        view.frame = presenter.view.frame
        remakeImageConstraints()
        view.layoutIfNeeded()

        setUpClosingAnimation(with: avatar)

        animatePresentation(of: avatar)
    }
    
    private func close() {
        onClose?()
    }

    private func moveImageFrame(to avatar: UIView) {
        imageView.snp.removeConstraints()
        imageView.translatesAutoresizingMaskIntoConstraints = true

        let avatarFrame = view.convert(avatar.frame, from: avatar.superview)
        imageView.frame = avatarFrame

        let size = min(imageView.bounds.width, imageView.bounds.height)
        imageView.layer.cornerRadius = size / 2
    }

    private func animatePresentation(of avatar: UIImageView) {
        let imageFrame = imageView.frame
        moveImageFrame(to: avatar)
        avatar.alpha = 0

        UIView.animate(withDuration: 0.5) { [self] in
            coverView.alpha = 0.5
            imageView.frame = imageFrame
            imageView.layer.cornerRadius = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.3) { [self] in
                closeButton.alpha = 1
                remakeImageConstraints()
            }
        }
    }

    private func setUpClosingAnimation(with avatar: UIView) {
        onClose = { [weak avatar, weak self] in
            guard
                let avatar = avatar,
                let self = self
            else {
                return
            }

            let duration = 0.8

            UIView.animateKeyframes(withDuration: duration, delay: 0.0,
                                    animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0,
                                   relativeDuration: 0.3 / duration) {

                    self.closeButton.alpha = 0.0
                }

                UIView.addKeyframe(withRelativeStartTime: 0.3 / duration,
                                   relativeDuration: 0.5 / duration ) {
                    self.coverView.alpha = 0.0
                    self.moveImageFrame(to: avatar)
                }
            }, completion: { _ in
                avatar.alpha = 1
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            })
        }
    }
}

fileprivate extension UIImage {
    var aspectRatio: CGFloat {
        size.height / size.width
    }
}

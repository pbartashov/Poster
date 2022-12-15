//
//  AvatarPresenter.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 11.12.2022.
//

import UIKit
import PosterKit

protocol CoverViewDelegate: AnyObject {
    func closeAvatarPresentation()
}

final class AvatarPresenter: UIViewController {

    typealias Transforms = (image: CGAffineTransform, frame: CGAffineTransform)
    // MARK: - Properties

    //    private weak var delegate: CoverViewDelegate?


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

        imageView.backgroundColor = .green
        return imageView
    }()

    private lazy var imageFrameView: UIView = {
        let view = UIView()
//        view.clipsToBounds = true
        view.backgroundColor = .red

        return view
    }()

    // MARK: - LifeCicle

    init(
        //        delegate: CoverViewDelegate?
    ) {
        //        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        remakeImageConstraints()
    }


    // MARK: - Metods

    private func initialize() {
//        imageFrameView.addSubview(imageView)
        [coverView,
         imageFrameView,
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

//        remakeImageConstraints()
    }

    private func remakeImageConstraints() {
        guard let imageAspectRatio = imageView.image?.aspectRatio,
              imageAspectRatio > 0 else {
            imageFrameView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }

            imageView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }

            return
        }

        let layoutFrame = view.safeAreaLayoutGuide.layoutFrame
        let viewAspectRatio = layoutFrame.height / layoutFrame.width

        imageFrameView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            if imageAspectRatio < viewAspectRatio {
                make.width.equalTo(view.safeAreaLayoutGuide)
                make.height.equalTo(imageFrameView.snp.width).multipliedBy(imageAspectRatio)
            } else {
                make.height.equalTo(view.safeAreaLayoutGuide)
                make.width.equalTo(imageFrameView.snp.height).dividedBy(imageAspectRatio)
            }
        }

//        imageView.snp.remakeConstraints { make in
//            make.center.equalToSuperview()
//            if imageAspectRatio < viewAspectRatio {
//                make.width.greaterThanOrEqualTo(imageFrameView)//.dividedBy(imageAspectRatio)
//                make.height.equalTo(imageFrameView)
//            } else {
//                make.height.equalTo(imageFrameView)//.multipliedBy(imageAspectRatio)
//                make.width.equalTo(imageFrameView)
//            }
//        }

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


//        let isImageVertical = (imageView.image?.isVertical == true)
//        let isViewVertical = view.frame.height > view.frame.width
//        imageView.snp.remakeConstraints { make in
////            make.top.leading.lessThanOrEqualToSuperview()
////            make.trailing.bottom.greaterThanOrEqualToSuperview()
//            make.center.equalToSuperview()
//
////            if isImageVertical {
////                make.width.equalToSuperview()
////            } else {
////                make.height.equalToSuperview()
////            }
//        }
//        imageView.makeEdgesConstraintsEqualToSuperview()
//        imageView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalToSuperview()
//        }
//        imageFrameView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//            make.top.leading.greaterThanOrEqualTo(view.safeAreaLayoutGuide).offset(Constants.UI.padding)
//            make.trailing.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-Constants.UI.padding)
//
//            make.center.equalTo(view.safeAreaLayoutGuide)
//
//            if isImageVertical && isViewVertical {
//                make.height.equalToSuperview().offset(-2 * Constants.UI.padding)
//            } else {
//                make.width.equalToSuperview().offset(-2 * Constants.UI.padding)
//            }
//        }
    }

    func present(_ avatar: UIImageView, on presenter: UIViewController) {
        guard let avatarParent = avatar.superview else { return }
        imageView.image = avatar.image
        remakeImageConstraints()

        presenter.addChild(self)
        presenter.view.addSubview(view)
        didMove(toParent: presenter)
        view.frame = presenter.view.frame
        view.layoutIfNeeded()

//        imageView.layer.bounds = .init(x: 9, y: 200, width: 200, height: 139)
//        imageView.layer.masksToBounds = true

        let avatarFrame = avatarParent.convert(avatar.frame, to: view)
        let transforms = calculateTransform(relativeTo: avatarFrame)

        let imageFrame = imageView.frame
//        let imageFrameFrame = imageFrameView.frame
//        imageFrameView.snp.removeConstraints()
        imageView.snp.removeConstraints()
//        imageFrameView.translatesAutoresizingMaskIntoConstraints = true
        imageView.translatesAutoresizingMaskIntoConstraints = true
//        imageFrameView.frame = avatarFrame
        imageView.frame = avatarFrame

//        let size = min(imageFrameView.bounds.width, imageFrameView.bounds.height)
//        imageFrameView.layer.cornerRadius = size / 2
        let size = min(imageView.bounds.width, imageView.bounds.height)
        imageView.layer.cornerRadius = size / 2
//        imageView.bounds = .init(x: 0, y: 0, width: 10, height: 100)
        imageView.clipsToBounds = true
//        imageView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.height.equalToSuperview()
//            make.width.equalToSuperview()
//        }

//        imageFrameView.setNeedsDisplay()
//        imageFrameView.transform = transforms.frame
//        imageView.transform = transforms.image

        //        avatar.alpha = 0.0
//        imageView.alpha = 0.3
        UIView.animate(withDuration: 0.5) { [self] in
            coverView.alpha = 0.5

//            imageFrameView.contentMode = .scaleAspectFit
//            imageFrameView.transform = .identity
//            imageView.transform = .identity
//            imageFrameView.layer.cornerRadius = 0


//            imageFrameView.frame = imageFrameFrame
            imageView.frame = imageFrame


            imageFrameView.alpha = 0.5
        } completion: { _ in
            UIView.animate(withDuration: 0.3) { [self] in
                closeButton.alpha = 1
//                remakeImageConstraints()
//                imageView.contentMode = .scaleAspectFit
            }
        }
    }
    
    private func close() {
        let duration = 0.8

        UIView.animateKeyframes(withDuration: duration, delay: 0.0,
                                animations: { [self] in
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: 0.3 / duration) {

                self.closeButton.alpha = 0.0
            }

            UIView.addKeyframe(withRelativeStartTime: 0.3 / duration,
                               relativeDuration: 0.5 / duration ) {
                self.coverView.alpha = 0.0
//                avatar.transform = .identity
//                avatar.layer.cornerRadius = avatar.bounds.width / 2
            }
        }, completion: { [self] _ in
            willMove(toParent: nil)
            view.removeFromSuperview()
            removeFromParent()
        })
    }

    private func calculateTransform(relativeTo avatarFrame: CGRect) -> Transforms {
        let size = min(imageFrameView.bounds.width, imageFrameView.bounds.height)
        imageFrameView.layer.cornerRadius = size / 2

        let imageViewFrame = imageFrameView.frame

        let scaleX = avatarFrame.width / imageFrameView.frame.width
        let scaleY = avatarFrame.height / imageFrameView.frame.height
        let frameScaleTransform = CGAffineTransform(scaleX: scaleX, y: scaleY)

        let imageScale = min(scaleX, scaleY)
        let imageScaleTransform = CGAffineTransform(scaleX: imageScale, y: imageScale)
        let translateTransform = CGAffineTransform(translationX: avatarFrame.midX - imageViewFrame.midX,
                                                   y: avatarFrame.midY - imageViewFrame.midY)

        return (image: imageScaleTransform.concatenating(translateTransform),
                frame: frameScaleTransform.concatenating(translateTransform))
    }

//    private func setFrame(for avatar: UIView) {
//        let bounds = view.convert(avatar.bounds, from: avatar)
//
//
//
//        let layoutFrame = tableView.safeAreaLayoutGuide.layoutFrame
//        let size = min(layoutFrame.size.width, layoutFrame.size.height) - 2 * Constants.UI.padding
//        let scale = size / avatar.bounds.width
//        let bounds = tableView.convert(avatar.bounds, from: avatar)
//        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
//        let translateTransform = CGAffineTransform(translationX: layoutFrame.midX - bounds.midX,
//                                                   y: layoutFrame.midY - bounds.midY)
//        avatar.transform = scaleTransform.concatenating(translateTransform)
//    }

}


fileprivate extension UIImage {
//    var isVertical: Bool {
//        size.height > size.width
//    }

    var aspectRatio: CGFloat {
        size.height / size.width
    }
}

//
//  DetailedPostView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 01.12.2022.
//

import UIKit
import Combine
import SnapKit
import iOSIntPackage
import PosterKit

enum DetailedPostViewButton {
    case save
    case cancel
    case avatar
}

protocol ViewWithImage: UIView {
    var image: UIImage? { get set }
}

protocol ViewWithText: UIView {
    var textContent: String? { get set }
}

extension UILabel: ViewWithText {
    var textContent: String? {
        get { text }
        set { text = newValue }
    }
}

extension UITextView: ViewWithText {
    var textContent: String? {
        get { text }
        set { text = newValue }
    }
}

extension UIImageView: ViewWithImage { }

extension ImagePickerView: ViewWithImage { }

final class DetailedPostView: ViewWithButton<DetailedPostViewButton> {

    // MARK: - Properties

    private var currentColorFilter: ColorFilter? {
        didSet {
            applyColorFilter()
        }
    }
    private var originalImage: UIImage?

//    private var originalPostViewModel: PostViewModel?

    private weak var imagePickerViewDelegate: ImagePickerViewDelegate?

    private let viewFactory: ViewFactoryProtocol&UserInfoViewFactory

    var isEditable: Bool = false {
        didSet {
            setupEditableViews()
        }
    }

    var image: UIImage? {
        get { postImageView?.image }
        set {
            originalImage = newValue
            postImageView?.image = newValue
//            let aspectRatio: CGFloat
//            if let size = newValue?.size {
//                aspectRatio = size.height / size.width
//            } else {
//                aspectRatio = Constants.UI.postImageAcpectRatio
//            }

            updatePostImageViewButtomConstraint()
        }
    }

    var content: String? {
        get { contentView?.textContent }
        set { contentView?.textContent = newValue ?? "" }
    }

    var authorAvatar: UIImage? {
        get { headerView.avatar }
        set { headerView.avatar = newValue }
    }

    var authorName: String? {
        get { headerView.name }
        set { headerView.name = newValue }
    }

    var authorStatus: String? {
        get { headerView.status }
        set { headerView.status = newValue }
    }

    var isBusy: Bool {
        get {
            !activityView.isHidden
        }
        set {
            activityView.isHidden = !newValue
        }
    }

    // MARK: - Views

    private lazy var headerView: UserInfoView = {
        let view = UserInfoView(viewFactory: viewFactory,
                                padding: Constants.UI.padding,
                                authorAvatarImageSize: Constants.UI.authorAvatarImageSize)
        view.backgroundColor = .brandBackgroundColor

        return view
    }()

    private lazy var postImageViewContainer = viewFactory.makeContainerView()
    private var postImageView: ViewWithImage? // = makeImageView()
//    private let postImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.layer.cornerRadius = Constants.UI.cornerRadius
//        imageView.layer.masksToBounds = true
//        imageView.layer.borderColor = UIColor.brandYellowColor.cgColor
//        imageView.layer.borderWidth = 1
//
//        return imageView
//    }()

//    private lazy var contentView1: UILabel = {
//        let label = viewFactory.makeTextLabel()
//        label.textAlignment = .natural
//        label.numberOfLines = 0
//        label.lineBreakMode = .byTruncatingTail
//
//        return label
//    }()
//
//    private lazy var contentView2: UITextView = {
//        let textview = UITextView()
//
//        textview.isScrollEnabled = false;
////        label.textAlignment = .natural
////        label.numberOfLines = 0
////        label.lineBreakMode = .byTruncatingTail
//
//        return textview
//    }()
    private lazy var contentViewContainer = viewFactory.makeContainerView()
      private var contentView: ViewWithText? // = makeContentView()

//    private lazy var avatarImageView: UIImageView = {
//        let imageView = UIImageView(frame: CGRect(x: 0,
//                                                  y: 0,
//                                                  width: Constants.UI.avatarImageSize,
//                                                  height: Constants.UI.avatarImageSize))
//        //        let imageView = UIImageView()
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.brandYellowColor.cgColor
//        imageView.layer.cornerRadius = imageView.frame.width / 2
//        imageView.layer.masksToBounds = true
//
//        let tapRecognizer = UITapGestureRecognizer(target: self,
//                                                   action: #selector(avatarTapped))
//        imageView.addGestureRecognizer(tapRecognizer)
//        imageView.isUserInteractionEnabled = true
//
//        return imageView
//    }()


    lazy var activityView: UIActivityIndicatorView = {
        let activity = viewFactory.makeActivityIndicatorView()

        return activity
    }()

    private lazy var colorFilterSelector: UISegmentedControl = {
        let off = UIAction(title: "offColorFilter".localized) { _ in
            self.currentColorFilter = nil
        }

        let noir = UIAction(title: "noirColorFilter".localized) { _ in
            self.currentColorFilter = .noir
        }

        let motionBlur = UIAction(title: "motionBlurColorFilter".localized) { _ in
            self.currentColorFilter = .motionBlur(radius: 10)
        }

        let invert = UIAction(title: "invertColorFilter".localized) { _ in
            self.currentColorFilter = .colorInvert
        }

        let control = UISegmentedControl(items: [off,
                                                 noir,
                                                 motionBlur,
                                                 invert])
        control.selectedSegmentIndex = 0

        return control
    }()
//    lazy var stackView: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.alignment = .fill
//        stack.spacing = Constants.UI.padding
//
//        return stack
//    }()





    // MARK: - LifeCicle

    init(viewFactory: ViewFactoryProtocol&UserInfoViewFactory,
         imagePickerViewDelegate: ImagePickerViewDelegate?
//         isEditable: Bool
         //         dateFormatter: DateFormatter
    ) {
        self.viewFactory = viewFactory
        self.imagePickerViewDelegate = imagePickerViewDelegate
//        self.isEditable = isEditable
        //        self.dateFormatter = dateFormatter
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        updatePostImageViewButtomConstraint()
//        activityView.layer.cornerRadius = activityView.bounds.width / 2
    }
    // MARK: - Metods

    private func initialize() {
        [colorFilterSelector,
         headerView,
         postImageViewContainer,
         contentViewContainer,
//         stackView,
         activityView,
        ].forEach {
            self.addSubview($0)
        }

//        [postImageView,
//         contentView
//        ].forEach {
//            stackView.addArrangedSubview($0)
//        }

        setupLayouts()
        setupEditableViews()
    }

    private func setupLayouts() {

        colorFilterSelector.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Constants.UI.padding)
            make.trailing.equalToSuperview().offset(-Constants.UI.padding)
        }

        headerView.snp.makeConstraints { make in
            make.top.equalTo(colorFilterSelector.snp.bottom).offset(Constants.UI.padding)
            make.leading.equalToSuperview().offset(Constants.UI.padding)
            make.trailing.equalToSuperview().offset(-Constants.UI.padding)
            make.height.equalTo(Constants.UI.postHeaderHeight)
        }

        activityView.snp.makeConstraints { make in
            make.center.equalTo(postImageViewContainer)
        }

//        stackView.snp.makeConstraints { make in
//            make.top.equalTo(headerView.snp.bottom).offset(Constants.UI.padding)
//            make.leading.trailing.equalTo(headerView)
//            make.bottom.equalToSuperview().offset(-Constants.UI.padding)
//        }





        postImageViewContainer.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constants.UI.padding)
            make.leading.trailing.equalTo(headerView)
//            make.height.equalTo(postImageView.snp.width).multipliedBy(Constants.UI.postImageAcpectRatio)
            make.bottom.equalTo(postImageViewContainer.snp.top).offset(postImageViewContainer.bounds.width * Constants.UI.postImageAcpectRatio)



//            make.bottom.equalToSuperview().offset(10 * -Constants.UI.padding)
        }

        contentViewContainer.snp.makeConstraints { make in
            make.top.equalTo(postImageViewContainer.snp.bottom).offset(Constants.UI.padding)
            make.leading.trailing.equalTo(headerView)




            make.bottom.equalToSuperview().offset(-Constants.UI.padding)
        }
    }

    private func setupEditableViews() {
        let translationX = bounds.width

        let newPostImageView = makeImageView()
        newPostImageView.image = postImageView?.image
        prepareForAnimation(newPostImageView, in: postImageViewContainer)

        let newContentView = makeContentView()

        newContentView.textContent = contentView?.textContent
        prepareForAnimation(newContentView, in: contentViewContainer)

        let oldPostImageView = postImageView
        let oldContentView = contentView
        postImageView = newPostImageView
        contentView = newContentView


        prepareForRemoving(oldPostImageView)
        prepareForRemoving(oldContentView)


//        oldPostImageView?.snp.removeConstraints()
//        oldContentView?.snp.removeConstraints()

        UIView.animate(withDuration: 0.5) { [self] in
            resetTransform(for: newPostImageView)
            resetTransform(for: newContentView)
   
            oldPostImageView?.transform = CGAffineTransform(translationX: -translationX, y: 0)
            oldContentView?.transform = CGAffineTransform(translationX: -translationX, y: 0)
            oldPostImageView?.alpha = 0
            oldContentView?.alpha = 0
        } completion: { _ in
            oldPostImageView?.removeFromSuperview()
            oldContentView?.removeFromSuperview()
        }
    }


    private func prepareForRemoving(_ view: UIView?) {
        // Для гладкой анимации. Новый view может отличаться по размерам от старого
        guard let view = view else { return }
//        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
//        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        view.setContentHuggingPriority(.defaultLow, for: .vertical)
//        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        view.snp.remakeConstraints { make in
//            make.top.leading.greaterThanOrEqualToSuperview()
//            make.trailing.bottom.lessThanOrEqualToSuperview()
//        }

        let bounds = view.bounds
        view.snp.remakeConstraints { make in
//            make.top.equalTo(10)
//            make.leading.equalTo(10)
//            make.trailing.equalTo(50)
//            make.bottom.equalTo(50)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(bounds.height)
            make.width.equalTo(bounds.width)
        }
    }

    private func prepareForAnimation(_ view: UIView, in container: UIView) {
        container.insertSubview(view, at: 0)
        view.makeEdgesConstraintsEqualToSuperview()

        view.transform3D = CATransform3DMakeRotation(.pi / 4, 0, 1, 0)
        view.layer.zPosition = 50
        view.layer.anchorPointZ = 520
    }

    private func resetTransform(for view: UIView) {
        view.transform3D = CATransform3DIdentity
        view.layer.zPosition = 0
        view.layer.anchorPointZ = 0
    }

    private func makeContentView() -> ViewWithText {
        if isEditable {
            let textview = viewFactory.makeTextView()
            textview.backgroundColor = .brandBackgroundGrayColor
            return textview
        } else {
            let label = viewFactory.makeTextLabel()
            label.textAlignment = .natural
            label.numberOfLines = 0
            label.lineBreakMode = .byTruncatingTail

            return label
        }
    }

    private func makeImageView() -> ViewWithImage {
        if isEditable {
            let imagePickerView = viewFactory.makePostImagePickerView(delegate: imagePickerViewDelegate)
            imagePickerView.addObserver(self,
                                        forKeyPath: "image",
                                        options: .new,
                                        context: nil)
            return imagePickerView
        } else {
            return viewFactory.makeImageView()
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "image" {
            updatePostImageViewButtomConstraint()
        }
    }

    #warning("addMotionEffect(<#T##effect: UIMotionEffect##UIMotionEffect#>)")






//
//    @objc private func avatarTapped() {
//        sendButtonTapped(.avatar)
//    }

    private func updatePostImageViewButtomConstraint() {
        let aspectRatio: CGFloat
        if let size = postImageView?.image?.size {
            aspectRatio = size.height / size.width
        } else {
            aspectRatio = Constants.UI.postImageAcpectRatio
        }

//        guard let postImageView = postImageView else { return }

        UIView.animate(withDuration: 0.3) { [self] in
            postImageViewContainer.snp.updateConstraints { make in
                make.bottom.equalTo(postImageViewContainer.snp.top)
                    .offset(postImageViewContainer.bounds.width * aspectRatio)
            }
            layoutIfNeeded()
        }
    }

    private func applyColorFilter() {
        postImageView?.image = originalImage

        guard
            let filter = currentColorFilter,
            let image = postImageView?.image
        else {
            return
        }

        Task {
            isBusy = true
            postImageView?.image = await withCheckedContinuation { continuation in
                ImageProcessor()
                    .processImage(sourceImage: image, filter: filter) { processed in
                        continuation.resume(returning: processed)
                    }

            }
            isBusy = false
        }
    }
//
//    private func setAvatarViewBorderWidth() {
//        switch avatarImageView.image {
//            case .none:
//                avatarImageView.layer.borderWidth = 1
//
//            case .some:
//                avatarImageView.layer.borderWidth = 0
//        }
//    }
}

//extension DetailedPostView {
//    var postViewModel: PostViewModel {
//        get { composePostViewModel() }
//        set {
//            originalPostViewModel = newValue
//            decomposePostViewModel(newValue)
//        }
//    }
//
//    func composePostViewModel() -> PostViewModel {
//        let post = Post
//PostViewModel(from: <#T##Post#>,
//              storageReader: <#T##StorageReaderProtocol#>)
//    }
//
//    func decomposePostViewModel(_ post: PostViewModel) {
//        <#function body#>
//    }
//}


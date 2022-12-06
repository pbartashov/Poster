//
//  ImagePickerView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 03.12.2022.
//

import UIKit

protocol ImagePickerViewDelegate: AnyObject {
    func present(_ viewController: UIViewController)
    func dismiss()
}

final class ImagePickerView: UIView {
    
    enum BorderRadiusType {
        case round
        case fixed(CGFloat)
    }
    
    // MARK: - Properties
    
    private weak var delegate: ImagePickerViewDelegate?
    
    private let clearImageButtonSize: CGFloat
    
    private let foregroundColor: UIColor

    var cornerRadius: BorderRadiusType = .round {
        didSet {
            switch cornerRadius {
                case .fixed(let radius):
                    imageView.layer.cornerRadius = radius
                    
                case .round:
                    break
            }
        }
    }
    
    var padding: CGFloat = 0 {
        didSet {
            setupLayouts()
        }
    }
    
    var borderWidth: CGFloat = 1 {
        didSet {
            setImageViewBorderWidth()
        }
    }
    
    var clearButtonOffset: CGFloat = 0 {
        didSet {
            setupButtonLayouts()
        }
    }
    
    var clearButtonBackgroundColor: UIColor? {
        get { clearImageButton.backgroundColor }
        set { clearImageButton.backgroundColor = newValue }
    }
    
    var font: UIFont {
        get { tapImageLabel.font }
        set { tapImageLabel.font = newValue }
    }
    
    var text: String? {
        get { tapImageLabel.text }
        set { tapImageLabel.text = newValue }
    }
    
    @objc dynamic
    var image: UIImage? {
        get { imageView.image }
        set {
            imageView.image = newValue
            setImageViewBorderWidth()
        }
    }
    
    // MARK: - Views
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = borderWidth
        imageView.layer.borderColor = foregroundColor.cgColor
        imageView.layer.masksToBounds = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(showImagePicker))
        imageView.addGestureRecognizer(tapRecognizer)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    let tapImageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private(set) lazy var clearImageButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: clearImageButtonSize)
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        let action = UIAction(image: image) { [weak self] _ in
            self?.image = nil
        }

        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = foregroundColor
        configuration.contentInsets = .init(top: 3,
                                            leading: 3,
                                            bottom: 3,
                                            trailing: 3)
        
        return UIButton(configuration: configuration, primaryAction: action)
    }()
    
    // MARK: - LifeCicle
    
    init(delegate: ImagePickerViewDelegate?,
         clearImageButtonSize: CGFloat = 10,
         foregroundColor: UIColor = .tintColor
    ) {
        self.delegate = delegate
        self.clearImageButtonSize = clearImageButtonSize
        self.foregroundColor = foregroundColor
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clearImageButton.layer.cornerRadius = clearImageButton.bounds.width / 2
        switch cornerRadius {
            case .round:
                imageView.layer.cornerRadius = imageView.bounds.width / 2
                
            case .fixed:
                break
        }
    }

    // MARK: - Metods
    
    private func initialize() {
        [tapImageLabel,
         imageView,
         clearImageButton
        ].forEach {
            self.addSubview($0)
        }
        
        setupLayouts()
    }
    
    private func setupLayouts() {
        tapImageLabel.snp.remakeConstraints { make in
            make.top.leading.equalTo(imageView).offset(padding)
            make.trailing.bottom.equalTo(imageView).offset(-padding)
        }
        
        imageView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupButtonLayouts()
    }
    
    private func setupButtonLayouts() {
        clearImageButton.snp.remakeConstraints { make in
            make.centerX.equalTo(self.snp.trailing).offset(-clearButtonOffset)
            make.centerY.equalTo(self.snp.top).offset(clearButtonOffset)
        }
    }
    
    @objc private func showImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        
        delegate?.present(picker)
    }
    
    private func setImageViewBorderWidth() {
        switch imageView.image {
            case .none:
                imageView.layer.borderWidth = borderWidth
                
            case .some:
                imageView.layer.borderWidth = 0
        }
    }
}

// MARK: - UIImagePickerControllerDelegate methods
extension ImagePickerView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.originalImage] as? UIImage else { return }
        self.image = image
        delegate?.dismiss()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.dismiss()
    }
}

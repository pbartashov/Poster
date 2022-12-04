//
//  ImagedLabel.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 25.09.2022.
//

import UIKit

final class ImagedLabel: UIStackView {

    // MARK: - Properties

    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    var text: String? {
        get {
            label.text
        }
        set {
            label.text = newValue
        }
    }
    
    // MARK: - Views
    
    let imageView: UIImageView
    let label: UILabel

    // MARK: - LifeCicle

    init(imageView: UIImageView,
         label: UILabel,
         spacing: CGFloat
    ) {
        self.imageView = imageView
        self.label = label

        super.init(frame: .zero)

        self.spacing = spacing
        self.alignment = .center

        [imageView,
         label
        ].forEach {
            self.addArrangedSubview($0)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

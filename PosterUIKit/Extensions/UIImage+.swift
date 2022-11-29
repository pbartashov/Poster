//
//  UIImage+.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import UIKit
import AVFoundation

extension UIImage {
    //    static let imagePlaceholder = UIImage(systemName: "photo")
    //: UIImage? = {
    //        let config = UIImage.SymbolConfiguration(scale: .large)
    //        return UIImage(systemName: "photo", withConfiguration: config)
    //    }()

    static let avatarPlaceholder: UIImage? = {
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        return UIImage(systemName: "person.circle", withConfiguration: config)
    }()

    func withAlpha(_ a: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { (_) in
            draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: a)
        }
    }

    func withTintColor(_ color: UIColor?) -> UIImage {
        if let color = color {
            return withTintColor(color, renderingMode: .alwaysOriginal)
        }
        return self
    }

    //https://nemecek.be/blog/157/how-to-resize-image-in-swift
    var asAvatarData: Data? {
        let maxSize = CGSize(width: Constants.UI.avatarMaxSize, height: Constants.UI.avatarMaxSize)

        let availableRect = AVFoundation.AVMakeRect(aspectRatio: self.size,
                                                    insideRect: .init(origin: .zero, size: maxSize))
        let targetSize = availableRect.size

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

        let resized = renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        return resized.jpegData(compressionQuality: Constants.UI.compressionQuality)
    }

    var pixelSize: CGSize {
        let heightInPoints = size.height
        let heightInPixels = heightInPoints * scale

        let widthInPoints = size.width
        let widthInPixels = widthInPoints * scale

        return CGSize(width: widthInPixels, height: heightInPixels)
    }
}

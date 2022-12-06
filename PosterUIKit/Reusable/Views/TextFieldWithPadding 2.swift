//
//  TextFieldWithPadding.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 28.11.2022.
//
//https://www.advancedswift.com/uitextfield-with-padding-swift/
import UIKit

class TextFieldWithPadding: UITextField {

    // MARK: - Properties

    var textPadding: UIEdgeInsets

    // MARK: - LifeCicle

    init(textPadding: UIEdgeInsets) {
        self.textPadding = textPadding
        super.init(frame: .zero)
    }

    override init(frame: CGRect) {
        self.textPadding = .zero
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

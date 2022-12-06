//
//  LabeledTextField.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 28.11.2022.
//
//
//import UIKit
//
//final class LabeledTextField: UIStackView {
//
//    // MARK: - Properties
//
//    var labelText: String? {
//        get {
//            label.text
//        }
//        set {
//            label.text = newValue
//        }
//    }
//
//    var text: String? {
//        get {
//            textField.text
//        }
//        set {
//            textField.text = newValue
//        }
//    }
//
//    // MARK: - Views
//
//    let label: UILabel
//    let textField: UITextField
//
//    // MARK: - LifeCicle
//
//    init(label: UILabel,
//         textField: UITextField,
//         spacing: CGFloat
//    ) {
//        self.label = label
//        self.textField = textField
//
//        super.init(frame: .zero)
//
//        self.spacing = spacing
//        self.alignment = .fill
//        self.axis = .vertical
//
//        [label,
//         textField
//        ].forEach {
//            self.addArrangedSubview($0)
//        }
//    }
//
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

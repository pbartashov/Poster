//
//  PhoneTextField.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 13.11.2022.
//
//https://stackoverflow.com/questions/32016350/mask-textfield-in-swift

import UIKit

class PhoneTextField: TextFieldWithPadding {
    
    // MARK: - Properties
    
    override var text: String? {
        get {
            super.text
        }
        set {
            super.text = formattedNumber(number: newValue)
        }
    }
    override var placeholder: String? {
        get {
            super.placeholder
        }
        set {
            super.placeholder = formattedNumber(number: newValue)
        }
    }
    
    var phoneNumberMask = "+_ (___) ___-__-__" {
        didSet {
            placeholder = phoneNumberMask
        }
    }
    
    var nextCursorPosition: UITextPosition {
        guard
            let text = text,
            let nextDigitIndex = text.firstIndex(of: "_")
        else {
            return endOfDocument
        }
        
        let offset = text.distance(from: text.startIndex, to: nextDigitIndex)
        return position(from: beginningOfDocument, offset: offset) ?? endOfDocument
    }
    
    // MARK: - LifeCicle
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        delegate = self
        placeholder = phoneNumberMask
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Metods
    
    func formattedNumber(number: String?) -> String? {
        guard let number = number else { return nil }
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for character in phoneNumberMask {
            if character == "_" && index < cleanPhoneNumber.endIndex {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(character)
            }
        }
        return result
    }
}

extension PhoneTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string:  String) -> Bool {
        guard let text = textField.text else { return false }
        
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        
        let newPosition = nextCursorPosition
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        
        return false
    }
}

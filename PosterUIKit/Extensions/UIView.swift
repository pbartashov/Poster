//
//  UIView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import UIKit

public extension UIView {
    static var identifier: String {
        String(describing: self)
    }

    func addSubviewsToAutoLayout(_ subviews: UIView...) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach {
            addSubview($0)
        }
    }

    func hideWithAnimation() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.alpha = 0
        }
    }

    func showWithAnimation() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.alpha = 1
        }
    }

    func makeEdgesConstraintsEqualToSuperview() {
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

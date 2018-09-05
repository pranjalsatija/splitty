//
//  HorizontalSeparator.swift
//  splitty
//
//  Created by Pranjal Satija on 8/29/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

// MARK: Base Class
@IBDesignable
class HorizontalSeparator: UIView {
    @IBInspectable var separatorColor: UIColor = UIColor(white: 151 / 255, alpha: 0.25) {
        didSet { backgroundColor = separatorColor }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureConstraints()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
}

// MARK: Setup
extension HorizontalSeparator {
    private func configureConstraints() {
        guard let superview = superview else {
            return
        }

        backgroundColor = separatorColor

        [
            heightAnchor.constraint(equalToConstant: 1),
            widthAnchor.constraint(equalTo: superview.widthAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ].forEach { $0.isActive = true }
    }
}

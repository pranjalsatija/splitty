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

    private var shouldUpdateConstraints = true
}

// MARK: Setup
extension HorizontalSeparator {
    override func updateConstraints() {
        super.updateConstraints()

        guard shouldUpdateConstraints, let superview = superview else {
            return
        }

        backgroundColor = separatorColor

        [
            heightAnchor.constraint(equalToConstant: 1),
            widthAnchor.constraint(equalTo: superview.widthAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ].forEach { $0.isActive = true }

        shouldUpdateConstraints = false
    }
}

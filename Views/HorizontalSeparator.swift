//
//  HorizontalSeparator.swift
//  splitty
//
//  Created by Pranjal Satija on 8/29/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

class HorizontalSeparator: UIView {
    @IBInspectable var separatorColor: UIColor = UIColor(white: 151 / 255, alpha: 0.25) {
        didSet { backgroundColor = separatorColor }
    }

    private var constraintsAreConfigured = false

    override func layoutSubviews() {
        if !constraintsAreConfigured, let superview = superview {
            backgroundColor = separatorColor

            [
                heightAnchor.constraint(equalToConstant: 1),
                widthAnchor.constraint(equalTo: superview.widthAnchor),
                leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor)
            ].forEach { $0.isActive = true }
        }
    }
}

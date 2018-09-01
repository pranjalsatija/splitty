//
//  UIView+Utilities.swift
//  splitty
//
//  Created by Pranjal Satija on 8/27/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

extension UIView {
    func pinToSuperview(padding: CGFloat = 0) {
        guard let superview = superview else {
            return
        }

        [
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding)
        ].forEach { $0.isActive = true }
    }
}

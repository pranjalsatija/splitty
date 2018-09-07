//
//  Spacer.swift
//  splitty
//
//  Created by Pranjal Satija on 9/5/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

// MARK: Base Class
class Spacer: UIView {
    var height: CGFloat? {
        didSet {
            shouldUpdateConstraints = true
            setNeedsUpdateConstraints()
        }
    }

    var width: CGFloat? {
        didSet {
            shouldUpdateConstraints = true
            setNeedsUpdateConstraints()
        }
    }

    private var shouldUpdateConstraints = true

    convenience init(height: CGFloat) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.height = height
    }

    convenience init(width: CGFloat) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.width = width
    }
}

// MARK: Setup
extension Spacer {
    override func updateConstraints() {
        super.updateConstraints()

        guard shouldUpdateConstraints else {
            return
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        shouldUpdateConstraints = false
    }
}

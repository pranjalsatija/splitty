//
//  TextTableViewCell.swift
//  splitty
//
//  Created by Pranjal Satija on 9/1/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: self)

    override var textLabel: UILabel? {
        return primaryLabel
    }

    override var detailTextLabel: UILabel? {
        return secondaryLabel
    }

    private var primaryLabel: UILabel!
    private var secondaryLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func configureSubviews() {
        func configurePrimaryLabel() {
            primaryLabel = UILabel()
            primaryLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            primaryLabel.numberOfLines = 0
            primaryLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(primaryLabel)

            [
                primaryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                primaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ].forEach { $0.isActive = true }
        }

        func configureSecondaryLabel() {
            secondaryLabel = UILabel()
            secondaryLabel.font = UIFont.preferredFont(forTextStyle: .body)
            secondaryLabel.numberOfLines = 0
            secondaryLabel.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
            secondaryLabel.textColor = UIColor.black.withAlphaComponent(0.5)
            secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(secondaryLabel)

            [
                secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: 0),
                secondaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                secondaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
            ].forEach { $0.isActive = true }
        }

        configurePrimaryLabel()
        configureSecondaryLabel()
    }
}

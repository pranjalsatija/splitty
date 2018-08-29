//
//  ToggleLabel.swift
//  splitty
//
//  Created by Pranjal Satija on 8/27/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

// MARK: Base Class
@IBDesignable
class ToggleLabel: UIControl {
    @IBInspectable var isOn: Bool = false {
        didSet { update() }
    }

    var font = UIFont.preferredFont(forTextStyle: .body)

    @IBInspectable var text: String? {
        didSet { textLabel?.text = text }
    }

    @IBInspectable var textColor: UIColor? {
        didSet { textLabel?.textColor = textColor ?? tintColor }
    }

    private var textLabel: UILabel!
    private var toggleControl: ToggleControl!
}

// MARK: Setup
extension ToggleLabel {
    override func layoutSubviews() {
        super.layoutSubviews()

        if textLabel == nil || toggleControl == nil {
            configureSubviews()
        }
    }

    private func configureSubviews() {
        func configureToggleControl() {
            toggleControl = ToggleControl()
            toggleControl.tintColor = tintColor
            toggleControl.translatesAutoresizingMaskIntoConstraints = false
            addSubview(toggleControl)

            [
                toggleControl.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                toggleControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                toggleControl.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
                toggleControl.widthAnchor.constraint(equalToConstant: 36),
                toggleControl.heightAnchor.constraint(equalToConstant: 36)
            ].forEach { $0.isActive = true }

            toggleControl.addTarget(self, action: #selector(toggled), for: .valueChanged)
        }

        func configureTextLabel() {
            textLabel = UILabel()
            textLabel.adjustsFontForContentSizeCategory = true
            textLabel.font = font
            textLabel.text = text
            textLabel.textColor = textColor ?? tintColor
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(textLabel)

            [
                textLabel.leadingAnchor.constraint(equalTo: toggleControl.trailingAnchor, constant: 8),
                textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                textLabel.centerYAnchor.constraint(equalTo: toggleControl.centerYAnchor)
            ].forEach { $0.isActive = true }
        }

        configureToggleControl()
        configureTextLabel()
    }
}

// MARK: User Interaction
extension ToggleLabel {
    private func update() {
        toggleControl?.isOn = isOn

        if isOn, let boldDescriptor = font.fontDescriptor.withSymbolicTraits([.traitBold]) {
            textLabel?.font = UIFont(descriptor: boldDescriptor, size: font.pointSize)
        } else {
            textLabel?.font = font
        }
    }

    @objc private func toggled(sender: ToggleControl) {
        isOn = sender.isOn
        sendActions(for: .valueChanged)
    }
}

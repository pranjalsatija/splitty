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
    var font = UIFont.preferredFont(forTextStyle: .body)

    @IBInspectable var isOn: Bool = false {
        didSet { update() }
    }

    @IBInspectable var text: String? {
        didSet { textLabel?.text = text }
    }

    @IBInspectable var textColor: UIColor? {
        didSet { textLabel?.textColor = textColor ?? tintColor }
    }

    override var tintColor: UIColor! {
        didSet { updateColors() }
    }

    private var shouldUpdateConstraints = true
    private var textLabel: UILabel!
    private var toggleControl: ToggleControl!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
}

// MARK: Setup
extension ToggleLabel {
    private func configureSubviews() {
        func configureToggleControl() {
            toggleControl = ToggleControl()
            toggleControl.translatesAutoresizingMaskIntoConstraints = false
            addSubview(toggleControl)
            toggleControl.addTarget(self, action: #selector(toggled), for: .valueChanged)
        }

        func configureTextLabel() {
            textLabel = UILabel()
            textLabel.adjustsFontForContentSizeCategory = true
            textLabel.font = font
            textLabel.text = text
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(textLabel)
        }

        configureToggleControl()
        configureTextLabel()
        updateColors()
    }

    private func updateColors() {
        textLabel.textColor = textColor ?? tintColor
        toggleControl.tintColor = tintColor
    }

    override func updateConstraints() {
        super.updateConstraints()

        guard shouldUpdateConstraints else {
            return
        }

        [
            toggleControl.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            toggleControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            toggleControl.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            toggleControl.widthAnchor.constraint(equalToConstant: 36),
            toggleControl.heightAnchor.constraint(equalToConstant: 36)
        ].forEach { $0.isActive = true }

        [
            textLabel.leadingAnchor.constraint(equalTo: toggleControl.trailingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textLabel.centerYAnchor.constraint(equalTo: toggleControl.centerYAnchor)
        ].forEach { $0.isActive = true }
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

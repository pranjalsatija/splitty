//
//  TableViewFooterView.swift
//  splitty
//
//  Created by Pranjal Satija on 9/5/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

// MARK: Base Class
class TableViewFooterView: UIView {
    var button: UIButton!
    var buttonText: String? {
        get { return button?.title(for: .normal) }
        set { button?.setTitle(newValue, for: .normal) }
    }

    var label: UILabel!
    var labelText: String? {
        get { return label?.text }
        set { label?.text = newValue }
    }

    override var tintColor: UIColor! {
        didSet {
            button?.backgroundColor = tintColor
        }
    }

    private var stackView: UIStackView!

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
extension TableViewFooterView {
    private func configureSubviews() {
        backgroundColor = .clear

        func configureStackView() {
            stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }

        func configureLabel() {
            label = UILabel()
            label.font = .preferredFont(forTextStyle: .headline)
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }

        func configureButton() {
            button = UIButton()
            button.backgroundColor = tintColor
            button.layer.cornerRadius = 10
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            button.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(button)

            button.heightAnchor.constraint(equalToConstant: 50).isActive = true

            let widthConstraint = button.widthAnchor.constraint(equalToConstant: 300)
            widthConstraint.priority = .defaultHigh
            widthConstraint.isActive = true
        }

        configureStackView()
        stackView.addArrangedSubview(Spacer(height: 16))
        configureLabel()
        stackView.addArrangedSubview(Spacer(height: 8))
        configureButton()
        frame.size.height = 500
    }

    func removeButton() {
        stackView.removeArrangedSubview(button)
        button.removeFromSuperview()
        button = nil
    }
}

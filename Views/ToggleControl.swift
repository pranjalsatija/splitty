//
//  ToggleControl.swift
//  splitty
//
//  Created by Pranjal Satija on 8/27/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

// MARK: Base Class
// Note: Providing explicit type annotations is necessary for Interface Builder to properly display @IBInspectables.
@IBDesignable
class ToggleControl: UIControl {
    @IBInspectable var animationDuration: Double = 0.125
    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet { configureSubviews() }
    }

    @IBInspectable var highlightedAlpha: CGFloat = 0.25

    @IBInspectable var internalPadding: CGFloat = 6 {
        didSet { configureSubviews() }
    }

    override var isHighlighted: Bool {
        didSet { updateHighlight() }
    }

    @IBInspectable var isOn: Bool = false {
        didSet { updateInnerView() }
    }

    override var tintColor: UIColor! {
        didSet { updateTintColor() }
    }

    private var innerView: UIView!
    private var outerView: UIView!
    private var shouldUpdateConstraints = true

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
extension ToggleControl {
    private func configureSubviews() {
        func configureOuterView() {
            outerView = UIView()
            outerView.layer.borderColor = tintColor.cgColor
            outerView.layer.borderWidth = borderWidth
            outerView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(outerView)
        }

        func configureInnerView() {
            innerView = UIView()
            innerView.backgroundColor = tintColor
            innerView.translatesAutoresizingMaskIntoConstraints = false
            outerView.addSubview(innerView)
            updateInnerView()
        }

        configureOuterView()
        configureInnerView()
        updateCornerRadii()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateCornerRadii()
    }

    override func updateConstraints() {
        super.updateConstraints()

        guard shouldUpdateConstraints else {
            return
        }

        innerView?.pinToSuperview(padding: internalPadding)
        outerView?.pinToSuperview()
        shouldUpdateConstraints = false
    }

    private func updateCornerRadii() {
        [self, outerView, innerView].compactMap { $0 }.forEach {(view) in
            view.clipsToBounds = true
            view.layer.cornerRadius = min(view.frame.width / 2, view.frame.height / 2)
        }
    }

    private func updateTintColor() {
        innerView?.backgroundColor = tintColor
        outerView?.layer.borderColor = tintColor.cgColor
    }
}

// MARK: User Interaction
extension ToggleControl {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false

        if touches.contains(where: { self.bounds.contains($0.location(in: self)) }) {
            isOn.toggle()
            sendActions(for: .valueChanged)
        }
    }

    private func updateHighlight() {
        let targetColor = isHighlighted ? tintColor.withAlphaComponent(highlightedAlpha) : .clear
        backgroundColor = targetColor
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveLinear], animations: {
            self.layer.backgroundColor = targetColor.cgColor
        }, completion: nil)
    }

    private func updateInnerView() {
        let targetAlpha: CGFloat = isOn ? 1 : 0
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.innerView.alpha = targetAlpha
            self.layoutIfNeeded()
        }, completion: nil)
    }
}

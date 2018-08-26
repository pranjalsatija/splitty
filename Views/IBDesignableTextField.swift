//
//  IBDesignableTextField.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

@IBDesignable
class IBDesignableTextField: UITextField {
    @IBInspectable var horizontalInset: CGFloat = 0
    @IBInspectable var verticalInset: CGFloat = 0

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: horizontalInset, dy: verticalInset)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: horizontalInset, dy: verticalInset)
    }
}

//
//  IBDesignableView.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

@IBDesignable
class IBDesignableView: UIView {
    @IBInspectable var borderColor: UIColor {
        get { return layer.borderColor.map { UIColor(cgColor: $0) } ?? .clear }
        set { layer.borderColor = newValue.cgColor }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}

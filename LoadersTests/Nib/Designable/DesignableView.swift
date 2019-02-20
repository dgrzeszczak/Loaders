//
//  DesignableView.swift
//  LoadersTests
//
//  Created by Dariusz Grzeszczak on 19/02/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

import UIKit
import Loaders

@IBDesignable
class DesignableView: UIView {

    @IBOutlet private var button: UIButton!

    @IBInspectable var title: String = "title" {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        Nib.add(to: self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Nib.add(to: self)
    }
}

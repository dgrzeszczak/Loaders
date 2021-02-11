//
//  Nib.swift
//  Loaders
//
//  Created by Dariusz Grzeszczak on 20/02/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

import UIKit

public struct Nib<View> where View: UIView {

    public static func add(to owner: View, bundle: Bundle? = nil) {

        let elements = String(describing: type(of: owner)).split(separator: ".")
        let nibName = String(elements[elements.count - 1])
        let bundle = bundle ?? Bundle(for: type(of: owner))
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: owner, options: nil).first as? UIView else {
            fatalError("Could not load nib named \(nibName)")
        }

        add(child: view, to: owner)
    }

    private static func add(child: UIView, to view: UIView) {
        child.frame = view.bounds
        child.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(child)
    }
}

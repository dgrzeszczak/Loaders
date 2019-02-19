//
//  Nib.swift
//  Loaders
//
//  Created by Dariusz Grzeszczak on 19/02/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

import UIKit

public protocol Nib: Loader { }

extension Nib {

    public static func add<View>(to owner: View) where View: UIView {
        let elements = String(describing: owner).split(separator: ".")
        let nibName = String(elements[elements.count - 1])
        let nib = UINib(nibName: nibName, bundle: Bundle(for: type(of: owner)))
        guard let view = nib.instantiate(withOwner: owner, options: nil).first as? View else {
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

//Reusable<View>
extension Nib {

    public static func load<View>(identifier: String = #function) -> Reusable<View> where View: UITableViewCell {
        let identifier = identifier.capitalizingFirstLetter()
        return Reusable(nibName: identifier, reuseIdentifier: identifier, bundle: { bundle } )
    }

    public static func load<View>(nibName: String, reuseIdentifier: String) -> Reusable<View> where View: UITableViewCell {
        return Reusable(nibName: nibName, reuseIdentifier: reuseIdentifier, bundle: { bundle } )
    }
}

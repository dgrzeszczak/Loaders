//
//  Nib.swift
//  Loaders
//
//  Created by Dariusz Grzeszczak on 19/02/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

import UIKit

public protocol Nibs: BundleLoader { }

//Reusable<View>
extension Nibs {

    public static func load<View>(identifier: String = #function) -> Reusable<View> {
        let identifier = identifier.capitalizingFirstLetter()
        return Reusable(nibName: identifier, reuseIdentifier: identifier, bundle: { bundle } )
    }

    public static func load<View>(nibName: String, reuseIdentifier: String) -> Reusable<View> {
        return Reusable(nibName: nibName, reuseIdentifier: reuseIdentifier, bundle: { bundle } )
    }
}

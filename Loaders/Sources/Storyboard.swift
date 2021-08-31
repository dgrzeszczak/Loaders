//
//  Storyboard.swift
//  Loaders
//
//  Created by Dariusz Grzeszczak on 19/02/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

import UIKit

public protocol Storyboard: BundleLoader { }

public protocol HasInitialController {
    associatedtype InitialControllerType: UIViewController = UIViewController

    static var initialViewController: Loader<InitialControllerType> { get }

    static func instantiateInitialViewController() -> InitialControllerType
}

extension Storyboard {

    public static func loader<Controller: UIViewController>(_ identifier: String = #function, completion: ((Controller) -> Void)? = nil) -> Loader<Controller> {

        let identifier = identifier.replacingOccurrences(of: "()", with: "")
        let storyboardName = String(describing: self)

        if identifier == "initialViewController" {
            return Loader<Controller>(identifier: nil, storyboardName: storyboardName, bundle: bundle, completion: completion)
        } else {
            return Loader<Controller>(identifier: identifier.capitalizingFirstLetter(), storyboardName: storyboardName, bundle: bundle, completion: completion)
        }
    }

    public static func load<Controller: UIViewController>(_ identifier: String = #function) -> Controller {
        return loader(identifier).load()
    }
}

extension Storyboard where Self: RawRepresentable, Self.RawValue == String {
    public func load<Controller: UIViewController>() -> Controller {
        return Self.load(rawValue)
    }

    public func loader<Controller: UIViewController>(completion: ((Controller) -> Void)? = nil) -> Loader<Controller> {
        return Self.loader(rawValue, completion: completion)
    }
}

extension ControllerLoader where Self: Storyboard, Self: RawRepresentable, Self.RawValue == String {
    public func load() -> UIViewController {
        return loader().load()
    }
}

extension HasInitialController where Self: Storyboard {

    public static func instantiateInitialViewController() -> InitialControllerType { return initialViewController.load() }
    public static var initialViewController: Loader<InitialControllerType> { return loader() }
}

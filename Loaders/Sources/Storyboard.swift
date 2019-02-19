//
//  Storyboard.swift
//  Loaders
//
//  Created by Dariusz Grzeszczak on 19/02/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

import UIKit

public protocol Storyboard: Loader { }

public protocol HasInitialController {
    associatedtype InitialControllerType: UIViewController = UIViewController
    static func initialViewController() -> InitialControllerType
}

extension Storyboard {

    public static func load<Controller: UIViewController>(_ identifier: String = #function) -> Controller {
        return load(identifier) as! Controller
    }

    public static func load(_ identifier: String = #function) -> UIViewController {
        let identifier = identifier.replacingOccurrences(of: "()", with: "")
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)

        var controller: UIViewController?
        if identifier == "initialViewController" {
            controller = storyboard.instantiateInitialViewController()
        } else {
            let identifier = identifier.replacingOccurrences(of: "instantiate", with: "")
            controller = storyboard.instantiateViewController(withIdentifier: identifier.capitalizingFirstLetter())
            if controller == nil {
                controller = storyboard.instantiateViewController(withIdentifier: identifier)
            }
        }

        if controller == nil {
            controller = storyboard.instantiateViewController(withIdentifier: identifier)
        }

        return controller!
    }
}

extension Storyboard where Self: RawRepresentable, Self.RawValue == String {
    public func load<Controller: UIViewController>() -> Controller {
        return Self.load(rawValue)
    }

    public func load() -> UIViewController {
        return Self.load(rawValue)
    }
}

extension HasInitialController where Self: Storyboard {
    public static func initialViewController() -> InitialControllerType { return load() }
}

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

    public static func loader<Controller: UIViewController>(_ identifier: String = #function) -> Loader<Controller> {

        let identifier = identifier.replacingOccurrences(of: "()", with: "")
        let storyboardName = String(describing: self)

        if identifier == "initialViewController" {
            return Loader<Controller>(identifier: nil, storyboardName: storyboardName, bundle: bundle)
        } else {
            return Loader<Controller>(identifier: identifier.capitalizingFirstLetter(), storyboardName: storyboardName, bundle: bundle)
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

    public func loader<Controller: UIViewController>() -> Loader<Controller> {
        return Self.loader(rawValue)
    }
}

extension HasInitialController where Self: Storyboard {

    public static func instantiateInitialViewController() -> InitialControllerType { return initialViewController.load() }
    public static var initialViewController: Loader<InitialControllerType> { return loader() }
}

// ViewModelDriven
extension Storyboard {
    public static func loader<Controller: UIViewController>(_ identifier: String = #function,
                                                            with viewModel: Controller.ViewModelType,
                                                            loadViewAndObserve: Bool = ViewModelDrivenConfig.Controller.loadViewAndObserve)
    -> Loader<Controller> where Controller: ViewModelDriven {

        return Loader<Controller>(loader: loader(identifier), with: viewModel, loadViewAndObserve: loadViewAndObserve)
    }

    public static func load<Controller: UIViewController>(_ identifier: String = #function,
                                                          with viewModel: Controller.ViewModelType,
                                                          loadViewAndObserve: Bool = ViewModelDrivenConfig.Controller.loadViewAndObserve)
    -> Controller where Controller: ViewModelDriven {

        return loader(identifier, with: viewModel, loadViewAndObserve: loadViewAndObserve).load()
    }
}

extension Storyboard where Self: RawRepresentable, Self.RawValue == String {
    public func load<Controller: UIViewController>(with viewModel: Controller.ViewModelType,
                                                   loadViewAndObserve: Bool = ViewModelDrivenConfig.Controller.loadViewAndObserve)
    -> Controller where Controller: ViewModelDriven {

        return Self.load(rawValue, with: viewModel, loadViewAndObserve: loadViewAndObserve)
    }

    public func loader<Controller: UIViewController>(with viewModel: Controller.ViewModelType,
                                                     loadViewAndObserve: Bool = ViewModelDrivenConfig.Controller.loadViewAndObserve)
    -> Loader<Controller> where Controller: ViewModelDriven {
        return Self.loader(rawValue, with: viewModel, loadViewAndObserve: loadViewAndObserve)
    }
}


extension HasInitialController where Self: Storyboard, InitialControllerType: ViewModelDriven {

    static func instantiateInitialViewController(with viewModel: InitialControllerType.ViewModelType,
                                                 loadViewAndObserve: Bool = ViewModelDrivenConfig.Controller.loadViewAndObserve)
    -> InitialControllerType {

        return initialViewController(with: viewModel, loadViewAndObserve: loadViewAndObserve).load()
    }

    static func initialViewController(with viewModel: InitialControllerType.ViewModelType,
                                      loadViewAndObserve: Bool = ViewModelDrivenConfig.Controller.loadViewAndObserve)
    -> Loader<InitialControllerType> {

        return Loader<InitialControllerType>(loader: initialViewController, with: viewModel, loadViewAndObserve: loadViewAndObserve)
    }
}

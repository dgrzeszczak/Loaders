//
//  Loader.swift
//  Loaders
//
//  Created by Dariusz Grzeszczak on 21/03/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

import UIKit

public protocol ControllerLoader {
    func load() -> UIViewController
}

public struct Loader<Controller: UIViewController> {

    private let factory: () -> Controller

    public init(factory: @escaping () -> Controller) {
        self.factory = factory
    }

    public init(identifier: String?, storyboardName: String, bundle: Bundle) {
        self.factory = {
            Loader<Controller>.storyboardFactory(identifier: identifier,
                                                 storyboardName: storyboardName,
                                                 bundle: bundle)
        }
    }

    private static func storyboardFactory(identifier: String?, storyboardName: String, bundle: Bundle) -> Controller {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)

        guard let identifier = identifier else {
            return storyboard.instantiateInitialViewController() as! Controller
        }

        return storyboard.instantiateViewController(withIdentifier: identifier)  as! Controller
    }

    public func load() -> Controller {
        return factory()
    }

    public var any: ControllerLoader {
        if let zelf = self as? Loader<UIViewController> { return zelf }
        return Loader<UIViewController>(factory: factory)
    }
}

extension ControllerLoader where Self: Storyboard, Self: RawRepresentable, Self.RawValue == String {
    public func load() -> UIViewController {
        return loader().load()
    }
}

extension Loader: ControllerLoader where Controller == UIViewController { }

// ViewModelDriven
extension Loader where Controller: ViewModelDriven {

    public init(identifier: String?,
                storyboardName: String,
                bundle: Bundle,
                with viewModel: Controller.ViewModelType,
                loadViewAndObserve: Bool = ViewModelDrivenConfig.Controller.loadViewAndObserve) {

        factory = {
            let controller = Loader<Controller>.storyboardFactory(identifier: identifier,
                                                                  storyboardName: storyboardName,
                                                                  bundle: bundle)
            controller.viewModel = viewModel
            if loadViewAndObserve {
                controller.loadViewIfNeeded()
                controller.observeViewModel()
            }
            return controller
        }
    }

    public init(loader: Loader<Controller>,
                with viewModel: Controller.ViewModelType,
                loadViewAndObserve: Bool = ViewModelDrivenConfig.Controller.loadViewAndObserve) {

        factory = { loader.load(with: viewModel, loadViewAndObserve: loadViewAndObserve) }
    }

    public func load(with viewModel: Controller.ViewModelType,
                     loadViewAndObserve: Bool = ViewModelDrivenConfig.Controller.loadViewAndObserve) -> Controller {

        let controller = load()
        controller.viewModel = viewModel
        if loadViewAndObserve {
            controller.loadViewIfNeeded()
            controller.observeViewModel()
        }
        return controller
    }
}

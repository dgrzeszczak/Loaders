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
            StoryboardFactory.create(identifier: identifier, storyboardName: storyboardName, bundle: bundle)
        }
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

enum StoryboardFactory {
    static func create<Controller>(identifier: String?,
                                   storyboardName: String,
                                   bundle: Bundle) -> Controller where Controller: UIViewController {

        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)

        guard let identifier = identifier else {
            return storyboard.instantiateInitialViewController() as! Controller
        }

        return storyboard.instantiateViewController(withIdentifier: identifier)  as! Controller
    }
}

extension Loader: ControllerLoader where Controller == UIViewController { }

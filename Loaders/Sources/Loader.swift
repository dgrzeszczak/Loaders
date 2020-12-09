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

    let factory: () -> Controller
    public let key: String

    public init(factory: @escaping () -> Controller, key: String, completion: ((Controller) -> Void)? = nil) {
        self.factory = {
            let controller: Controller = factory()
            completion?(controller)
            return controller
        }
        self.key = key
    }

    public init(identifier: String?, storyboardName: String, bundle: Bundle, completion: ((Controller) -> Void)? = nil) {

        let key = "\(bundle.bundleURL.lastPathComponent.split(separator: ".")[0]).\(storyboardName)"
        if let identifier = identifier {
            self.key = "\(key).\(identifier)"
        } else {
            self.key = key
        }

        print(self.key)
        self.factory = {
            let controller: Controller = StoryboardFactory.create(identifier: identifier,
                                                                  storyboardName: storyboardName,
                                                                  bundle: bundle)
            completion?(controller)
            return controller
        }
    }

    public func load() -> Controller {
        return factory()
    }

    public var any: ControllerLoader {
        if let zelf = self as? Loader<UIViewController> { return zelf }
        return Loader<UIViewController>(factory: factory, key: key)
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

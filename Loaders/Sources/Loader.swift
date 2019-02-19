//
//  Loader.swift
//  Loaders
//
//  Created by Dariusz Grzeszczak on 19/02/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

import Foundation

public protocol Loader {
    static var bundle: Bundle { get }
}

extension Loader {
    public static var bundle: Bundle {
        let allFrameworks = Bundle.allFrameworks
            .map { ($0.bundleURL.lastPathComponent.replacingOccurrences(of: ".framework", with: ""), $0) }

        let components = String(reflecting: self).split(separator: ".")
        guard components.count > 1 else { return Bundle.main } // shouldn't happen

        //first look on enclosing type
        let enclosingName = components[components.count - 2]
        if let enclosingBundle = allFrameworks.first(where: { $0.0 == enclosingName }) { return enclosingBundle.1 }

        guard components.count > 2 else { return Bundle.main }
        let firstName = components[0]
        if let firstBundle = allFrameworks.first(where: { $0.0 == firstName }) { return firstBundle.1 }

        return Bundle.main
    }
}

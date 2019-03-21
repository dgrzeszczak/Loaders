//
//  BundleLoader.swift
//  Loaders
//
//  Created by Dariusz Grzeszczak on 19/02/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

import Foundation

public protocol BundleLoader {
    static var bundle: Bundle { get }
}

extension BundleLoader {
    public static var bundle: Bundle {

        let components = String(reflecting: self).split(separator: ".")
        guard components.count > 1 else { return Bundle.main } // shouldn't happen

        //first look on enclosing type
        let enclosingName = components[components.count - 2]
        if let enclosingBundle = allBundles.first(where: { $0.0 == enclosingName }) { return enclosingBundle.1 }

        guard components.count > 2 else { return Bundle.main }
        let firstName = components[0]
        if let firstBundle = allBundles.first(where: { $0.0 == firstName }) { return firstBundle.1 }

        return Bundle.main
    }
}

private let allBundles: [(String, Bundle)] = {
    let appBundle = Bundle.allBundles
        .compactMap { bundle -> (String, Bundle)? in
            let lastPath = bundle.bundleURL.lastPathComponent
            if lastPath.hasSuffix(".app") {
                return (lastPath.replacingOccurrences(of: ".app", with: ""), bundle)
            }
            if lastPath.hasSuffix(".xctest") {
                return (lastPath.replacingOccurrences(of: ".xctest", with: ""), bundle)
            }
            return nil
    }

    let frameworks = Bundle.allFrameworks
        .map { bundle -> (String, Bundle) in
            (bundle.bundleURL
                .lastPathComponent
                .replacingOccurrences(of: ".framework", with: "")
                , bundle)
    }

    return appBundle + frameworks
}()

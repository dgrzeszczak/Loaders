//
//  ViewLoader.swift
//  Loaders
//
//  Created by Dariusz Grzeszczak on 10/12/2020.
//  Copyright © 2020 Dariusz Grzeszczak. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
extension Loader {

    public init<V>(_ view: @autoclosure @escaping () -> V) where V: View, Controller == UIHostingController<V> {
        key = String(reflecting: V.self)
        factory = { UIHostingController(rootView: view()) }
    }
}
#endif

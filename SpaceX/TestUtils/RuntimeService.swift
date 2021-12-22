//
//  RuntimeService.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 23/12/2021.
//

import UIKit

struct RuntimeService {
    static var httpClient: HTTPClientType {
        isRunningTests ? MockHTTPClient.shared.populate() : HTTPClient.shared
    }

    static var isRunningTests: Bool {
        #if DEBUG
        ProcessInfo().environment["UITesting"] == "YES"
        #else
        false
        #endif
    }

    static func optimiseForTestsIfTesting() {
        guard isRunningTests else { return }
        // Disable animations
        UIView.setAnimationsEnabled(false)

        // Disable hardware keyboards.
        let sel = NSSelectorFromString("setHardwareLayout:")
        UITextInputMode.activeInputModes.filter { $0.responds(to: sel) }.forEach { $0.perform(sel, with: nil) }
    }
}

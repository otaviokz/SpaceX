//
//  SpaceXApp.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import SwiftUI

@main
struct SpaceXApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            LaunchesView(viewModel: LaunchesViewModel(api: runtimeApi))
        }
    }

    private var runtimeApi: SpaceXAPIClientType {
        SpaceXAPIClient(httpClient: RuntimeService.httpClient)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        RuntimeService.optimiseForTestsIfTesting()
        return true
    }
}

//
//  Duck_TapeApp.swift
//  Duck Tape WatchKit Extension
//
//  Created by Ricardo Abreu on 02/12/2020.
//

import SwiftUI
import CoreMotion

@main
struct Duck_TapeApp: App {
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}

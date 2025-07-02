//
//  RunNowApp.swift
//  RunNow
//
//  Created by Foundation-005 on 20/06/25.
//

import SwiftUI
import SwiftData

@main
struct RunNowApp: App {
    var body: some Scene {
        WindowGroup {
            StartView()
                .modelContainer(for: DailyDataModel.self)
        }
    }
}

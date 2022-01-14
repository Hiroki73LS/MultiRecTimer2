//
//  BigLapTimerApp.swift
//  Shared
//
//  Created by 林宏樹 on 2022/01/12.
//

import SwiftUI

@main
struct BigLapTimerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView( total: ["0.00"], laptime: ["0.00"], laptimeTemp:0, lapNo: ["0"], lapn: 0)
        }
    }
}

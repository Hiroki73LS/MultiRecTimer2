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
            ContentView( total: [], laptime: [], lapNo: [], lapn: 1, nowTime: 0)
        }
    }
}

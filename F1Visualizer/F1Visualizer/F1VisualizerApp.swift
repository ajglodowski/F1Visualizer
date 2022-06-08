//
//  F1VisualizerApp.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/6/22.
//

import SwiftUI

@main
struct F1VisualizerApp: App {
    @StateObject private var modelData = ModelData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}

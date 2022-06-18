//
//  ContentView.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/6/22.
//

import SwiftUI

struct ContentView: View {
    
    //@ObservedObject var vm = ContentViewModel()
    //@ObservedObject var rdvm = RaceDataViewModel()
    
    var body: some View {
        TabView {
            CurrentPage()
                .tabItem {
                    //Label("Current season", systemImage: "list.bullet")
                    VStack {
                        Text("🏆 Current Season")
                    }
                }
            PreviousPage()
                .tabItem {
                    Label("All Seasons", systemImage: "list.bullet")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/6/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var vm = ContentViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
                Image("alonso")
                NavigationLink(destination: CurrentDriverStandings(drivers: vm.drivers)) {
                    CurrentDriverStandingsTile()
                        
                }
                .containerShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                //.fixedSize(horizontal: false, vertical: true)
                .padding([.horizontal, .bottom], 16)
                .frame(maxWidth: 1200)
            }
#if os(iOS)
            .background(Color(uiColor: .systemGroupedBackground))
#else
            .background(.quaternary.opacity(0.5))
#endif
        }
        .navigationViewStyle(.stack)
        .task {
            await vm.fetchData()
        }
    }
   /*
    var body: some View {
        WidthThresholdReader(widthThreshold: 520) { proxy in
            ScrollView(.vertical) {
                VStack {
                    CurrentDriverStandingsTile()
                }
                .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .fixedSize(horizontal: false, vertical: true)
                .padding([.horizontal, .bottom], 16)
                .frame(maxWidth: 1200)
            }
        }
        #if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
        #else
        .background(.quaternary.opacity(0.5))
        #endif
    }
    */
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  CurrentDriverStandings.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/6/22.
//

import SwiftUI

struct CurrentDriverStandingsTile: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @ObservedObject var vm = ContentViewModel()
    
    var body: some View {
        NavigationView {
            let iconShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
            VStack {
                Text("Current Standings")
                    .font(.title)
                if (!vm.drivers.isEmpty) {
                    HStack{
                        DriverPhotoTile(driver: vm.drivers[0], extraText: "🥇")
                            .frame(width: 300, height:300)
                        VStack {
                            DriverPhotoTile(driver: vm.drivers[1], extraText: "🥈")
                                .frame(width:150, height:150)
                            DriverPhotoTile(driver: vm.drivers[2], extraText: "🥉")
                                .frame(width:150, height:150)
                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        
        .task {
            await vm.fetchData()
        }
    }
}

struct CurrentDriverStandingsTile_Previews: PreviewProvider {
    static var previews: some View {
        CurrentDriverStandingsTile()
    }
}

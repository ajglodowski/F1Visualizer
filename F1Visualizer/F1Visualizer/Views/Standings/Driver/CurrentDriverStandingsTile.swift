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
        //let iconShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
        VStack {
            Text("Current Driver Standings")
                .font(.title)
            if (!vm.drivers.isEmpty) {
                VStack{
                    DriverPhotoTile(driver: vm.drivers[0], extraText: "🥇", color: Color(red: 241/255, green: 229/255, blue: 172/255))
                        //.frame(width: 250, height:250)
                    HStack {
                        DriverPhotoTile(driver: vm.drivers[1], extraText: "🥈", color: Color(red: 225/255, green: 225/255, blue: 225/255))
                            //.frame(width:150, height:150)
                        DriverPhotoTile(driver: vm.drivers[2], extraText: "🥉",color: Color(red: 206/255, green: 161/255, blue: 117/255))
                    }
                }

            }
        }
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

//
//  CurrentDriverStandings.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/6/22.
//

import SwiftUI

struct CurrentDriverStandingsRow: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @ObservedObject var vm = ContentViewModel()
    
    var body: some View {
        //let iconShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
        VStack (alignment: .leading) {
            Text("Current Driver Standings")
                .font(.title)
                .bold()
            if (!vm.drivers.isEmpty) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach (0..<vm.standings!.count) { ind in
                            NavigationLink(destination: DriverDetail(driverId: vm.drivers[ind].driverId)) {
                                DriverPhotoTile(driver: vm.drivers[ind], extraText: [String(ind+1)], color: getConstructorColor(constructor: vm.standings![ind].Constructors!.first!))
                                    .frame(width: 250, height:300)
                                //.shadow(.drop(color: .black, radius: 10))
                            }
                                
                        }
                    }
                }

            }
        }
        .task {
            await vm.fetchData()
        }
    }
}

struct CurrentDriverStandingsRow_Previews: PreviewProvider {
    static var previews: some View {
        CurrentDriverStandingsRow()
    }
}

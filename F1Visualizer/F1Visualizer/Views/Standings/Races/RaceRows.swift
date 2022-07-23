//
//  RaceRows.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 7/22/22.
//

import SwiftUI

struct RaceRows: View {
    
    @ObservedObject var vm = SeasonRaceDataViewModel()
    @State var loaded = false
    
    var body: some View {
        VStack {
            if (loaded) {
                ScrollView {
                    ForEach(0..<vm.allResults.count) { resultInd in
                        let result = vm.allResults[resultInd]
                        NavigationLink(destination: RaceDetail(current: false, year: result.season!, round: result.round!)) {
                            RaceRow(mostRecent: false, season: result.season!, round: result.round!)
                                .foregroundColor(.black)
                        }
                        /*
                        VStack {
                            Text(result.round!)
                            Text(getFlag(nationality: result.Races.first!.Circuit.Location.country))
                        }
                         */
                    }
                }
            } else {
                Text("Loading Race Data")
            }
        }
        .task {
            loaded = await vm.updateData(current: true, year: "2022")
        }
        .refreshable {
            loaded = await vm.updateData(current: true, year: "2022")
        }
    }
}

struct RaceRows_Previews: PreviewProvider {
    static var previews: some View {
        RaceRows()
    }
}

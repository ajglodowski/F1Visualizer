//
//  RaceDetail.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/8/22.
//

import SwiftUI

struct RaceDetail: View {
    
    @ObservedObject var rdvm = RaceDataViewModel()
    
    var year: String
    var round: String
    
    var raceName: String {
        (rdvm.rawRaceResult?.Races[0].raceName) ?? ""
    }
    
    var body: some View {
        //ScrollView {
            VStack (alignment:.leading) {
                if (!rdvm.drivers.isEmpty) {
                    RaceInfo(raceResult: rdvm.rawRaceResult ?? nil)
                } else {
                    Text("Loading")
                }
            }
        //}
        .refreshable {
            await rdvm.fetchAll(year: year, round: round)
        }
        .task {
            await rdvm.fetchAll(year: year, round: round)
        }
        .navigationTitle("Race Name")
    }
}

struct RaceInfo: View {
    var raceResult: RaceTable?
    var body: some View {
        Text("Load")
        if (raceResult != nil) {
            VStack(alignment:.leading) {
                HStack {
                    Text(raceResult!.Races[0].raceName)
                        .font(.title)
                    .bold()
                    Text(getFlag(nationality: raceResult!.Races[0].Circuit.Location.country))
                        .font(.largeTitle)
                    //Text(raceResult!.Races[0].Circuit.Location.country)
                }
                HStack {
                    Text(raceResult!.season )
                        .font(.title)
                    Text("Round "+raceResult!.round)
                        .font(.title)
                }
                HStack {
                    Text(raceResult!.Races[0].Circuit.Location.locality+", "+raceResult!.Races[0].Circuit.Location.country)
                    Text(raceResult!.Races[0].date)
                }
                
            }
        }
    }
}

struct RaceDetail_Previews: PreviewProvider {
    static var previews: some View {
        RaceDetail(year: "2022", round: "3")
    }
}

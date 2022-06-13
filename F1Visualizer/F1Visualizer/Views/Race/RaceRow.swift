//
//  MostRecentRaceTile.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/8/22.
//

import SwiftUI

struct RaceRow: View {
    
    @ObservedObject var rdvm = RaceDataViewModel()
    
    var mostRecent: Bool
    var year: String?
    var round: String?
    
    var raceName: String {
        ((rdvm.rawRaceResult?.Races[0].raceName ?? "") + (getFlag(nationality: rdvm.rawRaceResult?.Races[0].Circuit.Location.country ?? ""))) ?? ""
    }
    
    var body: some View {
        //let iconShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
        VStack (alignment:.leading) {
            if (mostRecent) {
                Text("Previous Race Result")
                    .font(.title)
                    .bold()
                Text(raceName)
            } else {
                Text(raceName)
                    .font(.title)
                    .bold()
            }
            if (!rdvm.drivers.isEmpty) {
                
                ScrollView(.horizontal){
                    HStack {
                        DriverPhotoTile(driver: rdvm.drivers[0], extraText: ["🥇"], color: Color(red: 241/255, green: 229/255, blue: 172/255))
                            //.frame(maxHeight:300)
                            .frame(width: 250, height:300)
                        DriverPhotoTile(driver: rdvm.drivers[1], extraText: ["🥈"], color: Color(red: 225/255, green: 225/255, blue: 225/255))
                            //.frame(maxHeight:300)
                            .frame(width: 250, height:300)
                        DriverPhotoTile(driver: rdvm.drivers[2], extraText: ["🥉"],color: Color(red: 206/255, green: 161/255, blue: 117/255))
                            //.frame(maxHeight:300)
                            .frame(width: 250, height:300)
                        ForEach (3..<rdvm.drivers.count) { ind in
                            DriverPhotoTile(driver: rdvm.drivers[ind], extraText: [String(ind+1)])
                                //.frame(maxHeight:300)
                                .frame(width: 250, height:300)
                        }
                    }
                }

            }
        }
        .padding()
        .task {
            if (mostRecent) { await rdvm.fetchMostRecentRace() }
            else { await rdvm.fetchAll(year: year!, round: round!) }
        }
    }
}

struct RaceRow_Previews: PreviewProvider {
    static var previews: some View {
        //RaceRow(mostRecent: true)
        RaceRow(mostRecent: false, year: "2022", round: "1")
    }
}

//
//  MostRecentRaceTile.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/8/22.
//

import SwiftUI

struct MostRecentRaceRow: View {
    
    @ObservedObject var rdvm = RaceDataViewModel()
    
    var raceName: String {
        (rdvm.rawRaceResult?.Races[0].raceName) ?? ""
    }
    
    var body: some View {
        //let iconShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
        VStack (alignment:.leading) {
            Text("Previous Race Result")
                .font(.title)
                .bold()
            if (!rdvm.drivers.isEmpty) {
                Text(raceName)
                ScrollView(.horizontal){
                    HStack {
                        DriverPhotoTile(driver: rdvm.drivers[0], extraText: "🥇", color: Color(red: 241/255, green: 229/255, blue: 172/255))
                            .frame(maxHeight:300)
                        DriverPhotoTile(driver: rdvm.drivers[1], extraText: "🥈", color: Color(red: 225/255, green: 225/255, blue: 225/255))
                            .frame(maxHeight:300)
                        DriverPhotoTile(driver: rdvm.drivers[2], extraText: "🥉",color: Color(red: 206/255, green: 161/255, blue: 117/255))
                            .frame(maxHeight:300)
                        ForEach (3..<rdvm.drivers.count) { ind in
                            DriverPhotoTile(driver: rdvm.drivers[ind], extraText: String(ind+1))
                                .frame(maxHeight:300)
                        }
                    }
                }

            }
        }
        .padding()
        .task {
            await rdvm.fetchMostRecentRace()
        }
    }
}

struct MostRecentRaceRow_Previews: PreviewProvider {
    static var previews: some View {
        MostRecentRaceRow()
    }
}

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
    var season: String?
    var round: String?
    
    var raceName: String {
        var flag = getFlag(nationality: rdvm.rawRaceResult?.Races[0].Circuit.Location.country ?? "")
        return ((rdvm.rawRaceResult?.Races[0].raceName ?? "") + flag)
    }
    
    func getTileColor(ind: Int) -> Color {
        switch ind {
        case 0:
            return Color(red: 241/255, green: 229/255, blue: 172/255)
        case 1:
            return Color(red: 225/255, green: 225/255, blue: 225/255)
        case 2:
            return Color(red: 206/255, green: 161/255, blue: 117/255)
        default:
            if (ind < 10) { return .green }
            else { return .red }
        }
        
    }
    
    func getPosText(ind: Int) -> String {
        if (ind == 0) { return "🥇" }
        else if (ind == 1) { return "🥈" }
        else if (ind == 2) { return "🥉" }
        else { return String(ind+1) }
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
                Text(rdvm.rawRaceResult?.Races[0].date ?? "")
            }
            if (!rdvm.drivers.isEmpty) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach (0..<rdvm.drivers.count) { ind in
                            NavigationLink(destination: DriverDetail(driverId: rdvm.drivers[ind].driverId)) {
                                DriverPhotoTile(driver: rdvm.drivers[ind], extraText: [getPosText(ind: ind)], color: getTileColor(ind: ind))
                                    //.frame(maxHeight:300)
                                    .frame(width: 250, height:300)
                            }
                        }
                    }
                    /*
                    .navigationDestination(for: Driver.self) { driver in
                        DriverDetail(driverId: driver.driverId)
                    }
                     */
                }

            }
        }
        .padding()
        .task {
            if (mostRecent) { await rdvm.fetchMostRecentRace() }
            else { await rdvm.fetchAll(year: season!, round: round!) }
        }
    }
}

struct RaceRow_Previews: PreviewProvider {
    static var previews: some View {
        //RaceRow(mostRecent: true)
        RaceRow(mostRecent: false, season: "2022", round: "1")
    }
}

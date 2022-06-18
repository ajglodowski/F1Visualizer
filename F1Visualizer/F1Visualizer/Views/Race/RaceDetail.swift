//
//  RaceDetail.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/8/22.
//

import SwiftUI

struct RaceDetail: View {
    
    @StateObject var rm = RaceDataViewModel()
    
    var current: Bool
    var year: String?
    var round: String?
    
    @State var raceSection: Int = 0
    //var raceSections: [any View] = [RaceInfo(), QualifyingResults()]
    
    var raceName: String {
        (rm.rawRaceResult?.Races[0].raceName ?? "") + getFlag(nationality: rm.rawRaceResult?.Races[0].Circuit.Location.country ?? "")
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment:.leading) {
                //RaceInfo(raceResult: rm.rawRaceResult ?? nil)
                if (!rm.drivers.isEmpty) {
                    VStack (alignment: .leading){
                        RaceInfo(raceResult: rm.rawRaceResult ?? nil)
                            .padding()
                        HStack {
                            Picker("Race Section", selection: $raceSection) {
                                Text("Race Results").tag(0)
                                Text("Qualifying Results").tag(1)
                            }
                            .pickerStyle(.segmented)
                            .padding()
                        }
                        switch raceSection {
                        case 0:
                            DriverResults(raceResult: rm.rawRaceResult ?? nil)
                                .padding()
                        case 1:
                            QualifyingResults(raceResult: rm.rawRaceResult ?? nil)
                                .padding()
                        default:
                            DriverResults(raceResult: rm.rawRaceResult ?? nil)
                                .padding()
                        }
                    }
                    //DriverResults(raceResult: rm.rawRaceResult ?? nil)
                        //.padding()
                    .navigationTitle(raceName)
                } else {
                    Text("Loading")
                }
            }
        }
        .refreshable {
            if (!current) { await rm.fetchAll(year: year!, round: round!) }
            else { await rm.fetchMostRecentRace() }
        }
        .task {
            if (!current) { await rm.fetchAll(year: year!, round: round!) }
            else { await rm.fetchMostRecentRace() }
        }
    }
}

struct RaceInfo: View {
    var raceResult: RaceTable?
    //@StateObject var rm = RaceDataViewModel()
    
    var fastestLap: Result? {
        if (raceResult != nil) {
            for result in (raceResult!.Races[0].Results) {
                if (result.FastestLap!.rank == "1") {
                    return result
                }
            }
            return nil
        } else {
            return nil
        }
    }
    
    var body: some View {
        //Text("Load")
        if (raceResult != nil) {
            VStack(alignment:.leading) {
                /*
                HStack {
                    Text(raceResult!.Races[0].raceName)
                        .font(.title)
                    .bold()
                    Text(getFlag(nationality: raceResult!.Races[0].Circuit.Location.country))
                        .font(.largeTitle)
                    //Text(raceResult!.Races[0].Circuit.Location.country)
                }
                 */
                HStack {
                    Text(raceResult!.season!)
                        .font(.title)
                    Text("Round "+raceResult!.round!)
                        .font(.title)
                }
                .bold()
                HStack {
                    var loc = raceResult!.Races[0].Circuit.Location
                    Text(loc.locality+", "+loc.country)
                    Text(raceResult!.Races[0].date)
                }
                HStack {
                    var winnerName = (raceResult!.Races[0].Results.first?.Driver.givenName)!+" "+(raceResult!.Races[0].Results.first?.Driver.familyName)!
                    Text("Race Winner: \(winnerName)")
                }
                HStack {
                    var fastestName = fastestLap!.Driver.givenName+" "+fastestLap!.Driver.familyName
                    var fastestTime = fastestLap!.FastestLap!.Time.time
                    Text("Fastest Lap: \(fastestName) \(fastestTime)")
                }
            }
        } else {
            Text("Load")
        }
    }
}

struct DriverResults: View {
    var raceResult: RaceTable?
    var body: some View {
        if (raceResult != nil) {
            //Text(raceResult!.Races.first!.Results.first?.Driver.givenName ?? "empty")
            ScrollView(.horizontal) {
                Grid(alignment: .center) {
                    GridRow {
                        Text("Position")
                        Text("Driver")
                        Text("Constructor")
                        Text("Result")
                        Text("Points")
                    }
                    Divider()
                    ForEach (0..<raceResult!.Races.first!.Results.count) { ind in
                        GridRow (alignment:.center) {
                            DriverRowRace(raceResult: raceResult!.Races.first!.Results[ind])
                            //Text("Here")
                        }
                        
                        if (ind != raceResult!.Races.first!.Results.count-1) {
                            GridRow {
                                Divider().gridCellColumns(5)
                            }
                        }
                        
                    }
                }
            }
        } else {
            Text("Loading Drivers")
        }
    }
}

struct DriverRowRace: View {
    
    //var raceResult: RaceTable?
    var raceResult: Result
    //var ind: Int
    
    var body: some View {
        if (raceResult != nil) {
            Text(raceResult.position)
            //Divider()
            HStack {
                Text(raceResult.Driver.givenName+" "+raceResult.Driver.familyName)
                Text(getFlag(nationality: raceResult.Driver.nationality))
            }
            HStack {
                //Text(raceResult.Constructor.name)
                Image(raceResult.Constructor.name.lowercased())
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 100, maxHeight: 40)
                    .padding(10)
                    //.background(.white)
                    .background(.ultraThickMaterial)
                    .cornerRadius(5)
            }
            HStack {
                if (raceResult.status == "Finished") {
                    Text(raceResult.Time!.time)
                    //Text("blah")
                } else {
                    if (raceResult.status.contains("+")) {
                        Text(raceResult.status)
                    } else {
                        Text("DNF: "+raceResult.status)
                    }
                }
            }
            HStack {
                if (raceResult.points != "0") {
                    Text("+"+raceResult.points)
                }
            }
            //Divider()
        } else {
            Text("Error loading")
        }
    }
}

struct QualifyingResults: View {
    var raceResult: RaceTable?
    var body: some View {
        if (raceResult != nil) {
            HStack(alignment: .center) {
                //Spacer()
                var results: [Result]? = raceResult?.Races.first?.Results.sorted(by:{ Int($0.grid)! < Int($1.grid)!}) ?? nil
                VStack (alignment: .center) {
                    ForEach(0..<results!.count) { resultInd in
                        if (resultInd % 2 == 0) {
                            let r = results![resultInd]
                            DriverPhotoTile(driver: r.Driver, extraText: [String(resultInd+1)], color: getConstructorColor(constructor: r.Constructor))
                                .frame(height: 300)
                                .frame(minWidth: 200)
                        }
                    }
                }
                VStack (alignment: .center) {
                    ForEach(0..<results!.count) { resultInd in
                        if (resultInd % 2 != 0) {
                            let o = results![resultInd]
                            DriverPhotoTile(driver: o.Driver, extraText: [String(resultInd+1)], color: getConstructorColor(constructor: o.Constructor))
                                .frame(height: 300)
                                .frame(minWidth: 200)
                        }
                    }
                }
                .padding(.top, 300)
                //Spacer()
            }
        } else {
            Text("Loading")
        }
    }
}

struct RaceDetail_Previews: PreviewProvider {
    static var previews: some View {
        RaceDetail(current: false, year: "2022", round: "1")
    }
}

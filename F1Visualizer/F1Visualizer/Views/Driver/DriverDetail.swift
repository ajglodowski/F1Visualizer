//
//  DriverDetail.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/6/22.
//

import SwiftUI

struct DriverDetail: View {
   
    var driverId: String
    
    @StateObject var driverVm = DriverDataViewModel()
    
    @State var showRaceWins = false
    
    var body: some View {
        
        ScrollView {
            if (driverVm.driver != nil) {
                if (!driverVm.loading) {
                    var driver = driverVm.driver!
                    var driverName = driver.givenName + " " + driver.familyName+getFlag(nationality: driver.nationality)
                    
                    Image(driver.driverId.lowercased())
                        .resizable()
                        .scaledToFit()
                        .background(getConstructorColor(constructor: driverVm.mostRecentConstructor!).gradient)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        //.frame(minWidth: 300)
                    VStack (alignment:.leading){
                        // Name
                        Text(driverName)
                            .font(.largeTitle)
                            .bold()
                        
                        // Most recent Team
                        HStack {
                            Text("Most Recent Team:")
                                .bold()
                            Text(driverVm.mostRecentConstructor?.name ?? "")
                        }
                        .font(.title)
                        
                        // Driver championship count if they've won
                        if (driverVm.championshipWinTotal != "0") {
                            HStack {
                                Text("Drivers Championships:")
                                    .bold()
                                Text(driverVm.championshipWinTotal)
                            }
                            .font(.title)
                        }
                        
                        // Best Result if no wins
                        if (driverVm.raceWinTotal == "0") {
                            VStack {
                                var bestResult = generateBestResult(races:driverVm.allRaces)
                                HStack {
                                    
                                    Text("Best Result:")
                                        .bold()
                                    Text("P\(bestResult.Results.first!.position) \(bestResult.raceName) \(bestResult.date)")
                                }
                                .font(.title)
                                RaceRow(mostRecent: false, season: bestResult.season, round: bestResult.round)
                            }
                            .background(.thinMaterial)
                            .cornerRadius(20)
                            .padding(.top, 10)
                        }
                        
                        // Race wins count
                        HStack {
                            Text("Race Wins: ")
                                .bold()
                            Text(driverVm.raceWinTotal)
                            //Spacer()
                        }
                        .font(.title)
                        
                        // Show Race wins
                        if (driverVm.raceWinTotal != "0") {
                            HStack(alignment: .center) {
                                Toggle(isOn: $showRaceWins) {
                                    Text("Show Race Wins?")
                                        .bold()
                                        .font(.title)
                                }
                            }
                            if (showRaceWins) {
                                let raceWins = generateRaceWins(races: driverVm.allRaces)
                                VStack {
                                    ForEach(0..<raceWins.count) { ind in
                                        NavigationLink(destination: RaceDetail(current: false, year: raceWins[ind].season, round: raceWins[ind].round)) {
                                            RaceRow(mostRecent: false, season: raceWins[ind].season, round: raceWins[ind].round)
                                            //.transition(.slide)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Podiums
                        HStack {
                            Text("Podium Finishes:")
                                .bold()
                            Text(driverVm.poduimFinishes)
                                
                        }
                        .font(.title)
                        
                        // All constructors
                        Text("All constructors:")
                            .bold()
                            .font(.title)
                        Text(generateConstructorList(races:driverVm.allRaces))
                            .font(.title)
                        
                        // Total Races
                        HStack {
                            Text("Races Driven:")
                                .bold()
                            Text(String(driverVm.allRaces.count))
                        }
                        .font(.title)
                        
                    }
                    .navigationTitle(driverName)
                } else {
                    Text("Loading Driver Data")
                }
            } else {
                Text("Loading \(driverId)")
                
            }
        }
        .refreshable {
            await driverVm.loadAllData(driverId: driverId)
        }
        .task{
            await driverVm.loadAllData(driverId: driverId)
        }
        .padding()
    }
    
}

struct DriverDetail_Previews: PreviewProvider {
    static var previews: some View {
        DriverDetail(driverId: "alonso")
    }
}

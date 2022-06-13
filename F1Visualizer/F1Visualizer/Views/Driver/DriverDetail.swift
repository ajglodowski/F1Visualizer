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
    
    var body: some View {
        ScrollView {
            if (driverVm.driver != nil) {
                if (!driverVm.loading) {
                    var driver = driverVm.driver!
                    var driverName = driver.givenName + " " + driver.familyName+getFlag(nationality: driver.nationality)
                    
                    Image(driver.driverId.lowercased())
                    VStack (alignment:.leading){
                        Text(driverName)
                            .font(.largeTitle)
                            .bold()
                        //Text(driver.driverId)
                            //.font(.title)
                        if (driverVm.championshipWinTotal != "0") {
                            Text("Drivers Championships: "+driverVm.championshipWinTotal)
                                .font(.title)
                        }
                        HStack {
                            var bestResult = generateBestResult(races:driverVm.allRaces)
                            Text("Best Result:")
                                .bold()
                            Text("P\(bestResult.Results.first!.position) \(bestResult.raceName) \(bestResult.date)")
                        }
                        .font(.title)
                        HStack {
                            Text("Race Wins: ")
                                .bold()
                            Text(driverVm.raceWinTotal)
                        }
                        .font(.title)
                        HStack {
                            Text("Podium Finishes:")
                                .bold()
                            Text(driverVm.poduimFinishes)
                                
                        }
                        .font(.title)
                        Text(generateConstructorList(races:driverVm.allRaces))
                            .font(.title)
                            .bold()
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
    }
    
}

struct DriverDetail_Previews: PreviewProvider {
    static var previews: some View {
        DriverDetail(driverId: "zhou")
    }
}

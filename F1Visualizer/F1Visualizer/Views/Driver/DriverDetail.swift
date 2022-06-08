//
//  DriverDetail.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/6/22.
//

import SwiftUI

struct DriverDetail: View {
   
    var driver: Driver
    
    @ObservedObject var driverVm = DriverDataViewModel()
    
    var body: some View {
        ScrollView {
            Image(driver.driverId.lowercased())
            VStack{
                Text(driver.givenName+" "+driver.familyName)
                    .font(.title)
                Text(driver.driverId)
                    .font(.title)
                Text("Drivers Championships: "+driverVm.championshipWinTotal)
                    .font(.title)
                Text("Race Wins: "+driverVm.raceWinTotal)
                    .font(.title)
                Text("Podium Finishes: "+driverVm.poduimFinishes)
                    .font(.title)
            }
        }
        .navigationTitle(driver.givenName)
        .refreshable {
            await driverVm.loadAllData(driverId: driver.driverId)
        }
        
        .task{
            await driverVm.loadAllData(driverId: driver.driverId)
        }
        
        
    }
    
}

struct DriverDetail_Previews: PreviewProvider {
    static var previews: some View {
        DriverDetail(driver: Driver(driverId: "alonso", permanentNumber: "1", code: "ALO", url: ".com", givenName: "Fernando", familyName: "Alonso", dateOfBirth: "10-10-2022", nationality: "Spanish"))
    }
}

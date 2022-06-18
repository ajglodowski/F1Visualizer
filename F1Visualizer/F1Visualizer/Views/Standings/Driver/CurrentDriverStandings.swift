//
//  CurrentDriverStandings.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/7/22.
//

import SwiftUI

struct CurrentDriverStandings: View {
    
    
    @ObservedObject var vm = ContentViewModel()
    
    var hardDrivers: [Driver]?
    
    var drivers: [Driver] {
        if (hardDrivers == nil) { return vm.drivers }
        else { return hardDrivers!}
    }
    
    var body: some View {
        //Text("Test")
        List(drivers) { driver in
            NavigationLink(destination: DriverDetail(driverId: driver.id)) {
                DriverStandingsRow(driver: driver, position: String(drivers.firstIndex(where: { $0 == driver})!+1))
            }
        }
        .task {
            await vm.fetchData()
        }
        .refreshable {
            await vm.fetchData()
        }
        .navigationTitle("Driver Standings")
        
    }
}

struct CurrentDriverStandings_Previews: PreviewProvider {
    static var previews: some View {
        let input = [Driver(driverId: "alonso", permanentNumber: "1", code: "ALO", url: ".com", givenName: "Fernando", familyName: "Alonso", dateOfBirth: "10-10-2022", nationality: "Spanish")]
        CurrentDriverStandings()
        //CurrentDriverStandings(hardDrivers: input)
    }
}

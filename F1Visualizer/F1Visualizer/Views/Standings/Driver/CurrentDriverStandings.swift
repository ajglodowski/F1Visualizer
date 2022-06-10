//
//  CurrentDriverStandings.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/7/22.
//

import SwiftUI

struct CurrentDriverStandings: View {
    
    var drivers: [Driver]
    
    var body: some View {
        NavigationStack {
            List(drivers) { driver in
                NavigationLink(value: driver) {
                    DriverStandingsRow(driver: driver, position: String(drivers.firstIndex(where: { $0 == driver})!+1))
                }
            }
            .navigationDestination(for: Driver.self) { driver in
                DriverDetail(driver: driver)
            }
        }
        .navigationTitle("Driver Standings")
    }
}

struct CurrentDriverStandings_Previews: PreviewProvider {
    static var previews: some View {
        let input = [Driver(driverId: "alonso", permanentNumber: "1", code: "ALO", url: ".com", givenName: "Fernando", familyName: "Alonso", dateOfBirth: "10-10-2022", nationality: "Spanish")]
        CurrentDriverStandings(drivers: input)
    }
}

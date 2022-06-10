//
//  DriverStandings Row.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/7/22.
//

import SwiftUI

struct DriverStandingsRow: View {
    var driver: Driver
    var position: String
    var body: some View {
        HStack {
            Text(position)
            Spacer()
            Image(driver.driverId.lowercased())
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
            Spacer()
            Text("\(driver.givenName) \(driver.familyName)")
            Spacer()
            Text(getFlag(nationality:driver.nationality))
                .font(.title)
            Spacer()
            Text(driver.code)
            Text(driver.permanentNumber)
        }
        .padding()
    }
}

struct DriverStandingsRow_Previews: PreviewProvider {
    static var previews: some View {
        DriverStandingsRow(driver: Driver(driverId: "alonso", permanentNumber: "1", code: "ALO", url: ".com", givenName: "Fernando", familyName: "Alonso", dateOfBirth: "10-10-2022", nationality: "Spanish"), position: "1")
    }
}

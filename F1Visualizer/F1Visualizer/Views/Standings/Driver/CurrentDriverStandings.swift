//
//  CurrentDriverStandings.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/7/22.
//

import SwiftUI

struct DriverTableObj: Identifiable {
    let driver: Driver
    let constructor: String
    let points: String
    let podiums: String
    let races: String
    let dnfs: String
    let avgResult: String
    let avgPos: String
    let avgGrid: String
    let raceChange: String
    let id = UUID()
}



struct CurrentDriverStandings: View {
    
    
    @ObservedObject var vm = SeasonRaceDataViewModel()
    
    func createDriverTableObj(driver: Driver) -> DriverTableObj? {
        if (loaded) {
            return DriverTableObj(driver: driver, constructor: vm.driverTeams[driver]!.name, points: String(vm.points[driver]!), podiums: String(vm.podiums[driver]!), races: String(vm.raceCount[driver]!), dnfs: String(vm.dnfCount[driver]!), avgResult: String(vm.avgResults[driver]!), avgPos: String(vm.avgPos[driver]!), avgGrid: String(vm.avgGrid[driver]!), raceChange: String(vm.avgPos[driver]!-vm.avgGrid[driver]!))
        } else { return nil }
    }
    
    func fillTableArray() -> [DriverTableObj] {
        if (loaded) {
            var output:[DriverTableObj] = []
            for driver in vm.drivers {
                output.append(createDriverTableObj(driver: driver)!)
            }
            print(output)
            return output.sorted {$0.points > $1.points}
        } else {
            return []
        }
    }
    
    @State private var tableObjects: [DriverTableObj] = []
    @State private var sortOrder = [KeyPathComparator(\DriverTableObj.points)]
    //@State private var selection: DriverTableObj.ID?
    
    @State var loaded = false
    
    var body: some View {
        //Text("Test")
        VStack {
            if (loaded) {
                VStack {
                    Text("Hello")
                    Table(tableObjects, sortOrder: $sortOrder) {
                        TableColumn("Driver Name", value: \.driver.familyName)
                        TableColumn("Constructor", value: \.constructor)
                        TableColumn("Points", value:\.points)
                        TableColumn("Podiums", value:\.podiums)
                        TableColumn("Avg Pos", value:\.avgPos)
                        TableColumn("Avg Grid", value:\.avgGrid)
                        TableColumn("Race +/-", value:\.raceChange)
                        TableColumn("Average Points", value:\.avgResult)
                        TableColumn("DNFs", value:\.dnfs)
                        TableColumn("Races", value:\.races)
                    }
                    
                    .onChange(of: sortOrder) { newOrder in
                        tableObjects.sort(using: newOrder)
                    }
                }
            } else {
                Text("Loading Table")
            }
            
        }
        .task {
            loaded = await vm.updateData(current: true, year: "2022")
            tableObjects = fillTableArray()
        }
        .refreshable {
            loaded = await vm.updateData(current: true, year: "2022")
            tableObjects = fillTableArray()
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

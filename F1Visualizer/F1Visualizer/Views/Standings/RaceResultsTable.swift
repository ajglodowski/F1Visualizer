//
//  RaceResultsTable.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 7/17/22.
//

import SwiftUI

struct RaceResultsTable: View {
    
    @ObservedObject var vm = SeasonRaceDataViewModel()
    @State var loaded = false
    
    func getBgColor(ind: Int) -> Color {
        switch ind {
        case 1:
            return Color(red: 241/255, green: 229/255, blue: 172/255)
        case 2:
            return Color(red: 225/255, green: 225/255, blue: 225/255)
        case 3:
            return Color(red: 206/255, green: 161/255, blue: 117/255)
        default:
            if (ind == -1) { return .gray }
            if (ind < 11) { return .green }
            else { return .red }
        }
        
    }
    
    var body: some View {
        VStack {
            if (loaded) {
                ScrollView {
                    Grid() {
                        
                        GridRow {
                            Text("Round")
                            ForEach(0..<vm.allResults.count) { resultInd in
                                let result = vm.allResults[resultInd]
                                VStack {
                                    Text(result.round!)
                                    Text(getFlag(nationality: result.Races.first!.Circuit.Location.country))
                                }
                            }
                        }
                        
                        let drivers = vm.drivers.sorted{ vm.points[$0]! > vm.points[$1]!}
                        ForEach(drivers) { driver in
                            GridRow {
                                Text(driver.code)
                                ForEach(0..<vm.allResults.count) { resultInd in
                                    let driverAr = vm.allResults[resultInd].Races.first!.Results
                                    let result = driverAr.first(where: { $0.Driver == driver})
                                    let posInt = Int(result?.position ?? "-1")!
                                    Text(result?.position ?? "DNP")
                                        .frame(width: 40, height: 40)
                                        .background(getBgColor(ind:posInt))
                                        .cornerRadius(5)
                                    
                                }
                            }
                        }
                    }
                }
            } else {
                Text("Loading Data")
            }
        }
        .task {
            loaded = await vm.updateData(current: true, year: "2022")
        }
        .refreshable {
            loaded = await vm.updateData(current: true, year: "2022")
        }
    }
}

struct RaceResultsTable_Previews: PreviewProvider {
    static var previews: some View {
        RaceResultsTable()
    }
}

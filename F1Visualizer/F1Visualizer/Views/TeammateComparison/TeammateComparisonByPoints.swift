//
//  TeammateComparisonByPoints.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 7/4/22.
//

import SwiftUI

struct TeammateComparisonByPoints: View {
    var allResults: [StandingList]
    
    @State var sortMode: Int = 0
    @State var comparator: Int = 0
    
    var difs = [Constructor: Int]()
    
    func getConstructors(standings: [StandingItem]) -> [Constructor] {
        var output = [Constructor]()
        for standing in standings {
            if (!output.contains(standing.Constructors!.first!)) {
                output.append(standing.Constructors!.first!)
            }
        }
        return output
    }
    
    func generateDifs(standings: [StandingItem], constructors: [Constructor]) -> [Constructor: Int] {
        var output = [Constructor: Int]()
        for constructor in constructors {
            let pair = generatePairing(standings: standings, constructor: constructor)
            let thisDif = Int(pair[0].points)! - Int(pair[1].points)!
            output[constructor] = thisDif
        }
        return output
    }
    
    func generatePercentageDifs(standings: [StandingItem], constructors: [Constructor]) -> [Constructor: Float] {
        var output = [Constructor: Float]()
        for constructor in constructors {
            let pair = generatePairing(standings: standings, constructor: constructor)
            if (Int(pair[1].points)! != 0) {
                let thisDif = Float(Int(pair[0].points)! / Int(pair[1].points)!)
                output[constructor] = thisDif
            } else {
                output[constructor] = 10000000
            }
        }
        return output
    }
    
    func generatePairing(standings: [StandingItem], constructor: Constructor) -> [StandingItem] {
        return standings.filter { $0.Constructors!.first! == constructor}.sorted { Int($0.points)! > Int($1.points)! }
    }
    
    var conList: [Constructor] {
        let constructors = getConstructors(standings: allResults.last!.DriverStandings!)
        if (sortMode == 0) { // Largest dif
            if (comparator == 0) { // By points
                let difs = generateDifs(standings: allResults.last!.DriverStandings!, constructors: constructors)
                return constructors.sorted { difs[$0]! > difs[$1]! }
            } else { // By percentage
                let difs = generatePercentageDifs(standings: allResults.last!.DriverStandings!, constructors: constructors)
                return constructors.sorted { difs[$0]! > difs[$1]! }
            }
        } else { // Smallest Dif
            if (comparator == 0) { // By points
                let difs = generateDifs(standings: allResults.last!.DriverStandings!, constructors: constructors)
                return constructors.sorted { difs[$0]! < difs[$1]! }
            } else { // By percentage
                let difs = generatePercentageDifs(standings: allResults.last!.DriverStandings!, constructors: constructors)
                return constructors.sorted { difs[$0]! < difs[$1]! }
            }
        }
    }
    
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                if (!allResults.isEmpty) {
                    Text("Point Comparison")
                        .padding()
                        .font(.title)
                    Picker("Sort by:", selection: $comparator) {
                        Text("By Points").tag(0)
                        Text("By Percentage").tag(1)
                    }
                    .pickerStyle(.segmented)
                    Picker("Sort by:", selection: $sortMode) {
                        Text("Largest Gap").tag(0)
                        Text("Smallest Gap").tag(1)
                    }
                    .pickerStyle(.segmented)
                    Divider()
                    ForEach(conList) { constructor in
                        VStack {
                            Text(constructor.name)
                                .font(.title)
                                .bold()
                            let pairings = generatePairing(standings: allResults.last!.DriverStandings!, constructor: constructor)
                            ScrollView(.horizontal) {
                                HStack{
                                    ForEach(0..<pairings.count) { pairInd in
                                        VStack {
                                            DriverPhotoTile(driver: pairings[pairInd].Driver!, color: getConstructorColor(constructor: constructor))
                                            Text("\(pairings[pairInd].points) points")
                                                .font(.title)
                                        }
                                        
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    Text("Loading Data")
                }
            }
        }
    }
}

//
//  TeammateComparisonHeadToHead.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 7/4/22.
//

import SwiftUI

struct TeammateComparisonHeadToHead: View {
    
    @ObservedObject var vm = SeasonRaceDataViewModel()
    
    @State var sortingCat: Int = 0
    @State var categoryShown: Int = 0
    
    @State var loaded: Bool = false
    
    func totalRounds(driver: Driver) -> Int {
        var output = 0
        for race in vm.allResults {
            let result = race.Races.first!.Results
            for d in result {
                if (d.Driver == driver) { output += 1 }
            }
        }
        return output
    }
    
    func winPercentage(driver: Driver) -> Double {
        return Double(vm.headWins[driver]!) / Double(totalRounds(driver: driver))
    }
    
    func constWinDif(constructor: Constructor) -> Int {
        if (!vm.headWins.isEmpty && !vm.loading) {
            let pair = vm.driverPairs[constructor]!.sorted { vm.headWins[$0]! >  vm.headWins[$1]!}
            return vm.headWins[pair[0]]! - vm.headWins[pair[1]]!
        } else {
            return -1
        }
    }
    
    func constAvgResult(constructor: Constructor) -> Float {
        if (!vm.avgResults.isEmpty && !vm.loading) {
            let pair = vm.driverPairs[constructor]!.sorted { vm.avgResults[$0]! >  vm.avgResults[$1]!}
            return vm.avgResults[pair[0]]! - vm.avgResults[pair[1]]!
        } else {
            return -1
        }
    }
    
    var sortedConstructors: [Constructor] {
        switch sortingCat {
        case 1:
            if (categoryShown == 0) {
                return vm.constructors.sorted { constWinDif(constructor: $0) < constWinDif(constructor: $1) }
            } else {
                return vm.constructors.sorted { constAvgResult(constructor: $0) < constAvgResult(constructor: $1) }
            }
        default:
            if (categoryShown == 0) {
                return vm.constructors.sorted { constWinDif(constructor: $0) > constWinDif(constructor: $1) }
            } else {
                return vm.constructors.sorted { constAvgResult(constructor: $0) > constAvgResult(constructor: $1) }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // !vm.allResults.isEmpty && !vm.headWins.isEmpty && !vm.avgResults.isEmpty && !vm.loading
            if (loaded) {
                Text("Teammate Head to Heads")
                    .font(.title)
                Picker("Category", selection: $categoryShown) {
                    Text("H-H Wins").tag(0)
                    Text("Average H-H Result").tag(1)
                }
                .pickerStyle(.segmented)
                Picker("Sort by", selection: $sortingCat) {
                    Text("Largest Difference").tag(0)
                    Text("Closest Battle").tag(1)
                }
                .pickerStyle(.segmented)
                Divider()
                if (categoryShown != 1) {
                    ScrollView {
                        ForEach(sortedConstructors) { constructor in
                            VStack (alignment: .center) {
                                Text(constructor.name)
                                    .font(.headline)
                                    .bold()
                                ScrollView(.horizontal) {
                                     HStack {
                                         let pair = vm.driverPairs[constructor]!.sorted { vm.headWins[$0]! >  vm.headWins[$1]!}
                                        ForEach(pair) { driver in
                                            VStack {
                                                Text("\(vm.headWins[driver]!)")
                                                Text("Wins")
                                                DriverPhotoTile(driver: driver, color: getConstructorColor(constructor: constructor))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    //.padding()
                } else {
                    ScrollView {
                        ForEach(sortedConstructors) { constructor in
                            VStack (alignment: .center) {
                                Text(constructor.name)
                                    .font(.headline)
                                    .bold()
                                ScrollView(.horizontal) {
                                    HStack {
                                        if (!vm.avgResults.isEmpty) {
                                            let pair = vm.driverPairs[constructor]!.sorted { vm.avgResults[$0]! <  vm.avgResults[$1]!}
                                            ForEach(pair) { driver in
                                                VStack {
                                                    Text("Average Finishing Position")
                                                    Text("\(vm.avgResults[driver]!)")
                                                    DriverPhotoTile(driver: driver, color: getConstructorColor(constructor: constructor))
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                Text("Loading Season Data")
            }
        }
        .padding()
        .task {
            loaded = await vm.updateData(current: true, year: "2022")
        }
        .refreshable {
            loaded = await vm.updateData(current: true, year: "2022")
        }
    }
}

struct TeammateComparisonHeadToHead_Previews: PreviewProvider {
    static var previews: some View {
        TeammateComparisonHeadToHead()
    }
}

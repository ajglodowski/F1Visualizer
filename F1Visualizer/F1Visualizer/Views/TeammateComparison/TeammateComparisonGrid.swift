//
//  TeammateComparisonGrid.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 7/9/22.
//

import SwiftUI

struct TeammateComparisonGrid: View {
    
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
        return Double(vm.gridHeadWins[driver]!) / Double(totalRounds(driver: driver))
    }
    
    func constWinDif(constructor: Constructor) -> Int {
        if (!vm.headWins.isEmpty && !vm.loading) {
            let pair = vm.driverPairs[constructor]!.sorted { vm.gridHeadWins[$0]! >  vm.gridHeadWins[$1]!}
            return vm.gridHeadWins[pair[0]]! - vm.gridHeadWins[pair[1]]!
        } else {
            return -1
        }
    }
    
    func constAvgResult(constructor: Constructor) -> Float {
        if (!vm.avgGrid.isEmpty && !vm.loading) {
            let pair = vm.driverPairs[constructor]!.sorted { vm.avgGrid[$0]! >  vm.avgGrid[$1]!}
            return vm.avgGrid[pair[0]]! - vm.avgGrid[pair[1]]!
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
                Text("Teammate Grid Head to Heads")
                    .font(.title)
                Text("Note: The publicly avaiable data uses grid position not qualifying. The places are where drivers started on the grid after sprint races and penalties")
                    .font(.subheadline)
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
                                         let pair = vm.driverPairs[constructor]!.sorted { vm.gridHeadWins[$0]! >  vm.gridHeadWins[$1]!}
                                        ForEach(pair) { driver in
                                            VStack {
                                                Text("\(vm.gridHeadWins[driver]!)")
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
                                        if (!vm.avgGrid.isEmpty) {
                                            let pair = vm.driverPairs[constructor]!.sorted { vm.avgGrid[$0]! <  vm.avgGrid[$1]!}
                                            ForEach(pair) { driver in
                                                VStack {
                                                    Text("Average Grid Position")
                                                    Text("\(vm.avgGrid[driver]!)")
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

struct TeammateComparisonGrid_Previews: PreviewProvider {
    static var previews: some View {
        TeammateComparisonGrid()
    }
}

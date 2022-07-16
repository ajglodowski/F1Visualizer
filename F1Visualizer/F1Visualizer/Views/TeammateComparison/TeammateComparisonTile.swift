//
//  TeammateComparisonTile.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 7/14/22.
//

import SwiftUI

struct TeammateComparisonTile: View {
    
    @ObservedObject var vm = SeasonRaceDataViewModel()
    
    @State var loaded: Bool = false
    
    var body: some View {
        NavigationLink(destination: TeammateComparison()) {
            VStack(alignment:.leading) {
                if (loaded) {
                    let displayedConstructor = vm.constructors[Int.random(in: 0..<vm.constructors.count)]
                    Text("Teammate Comparison")
                        .font(.title)
                    Text(displayedConstructor.name)
                        .font(.headline)
                        .bold()
                    ScrollView(.horizontal){
                        HStack {
                            let drivers = vm.driverPairs[displayedConstructor]!.sorted { vm.headWins[$0]! > vm.headWins[$1]! }
                            ForEach(0..<drivers.count) { ind in
                                let driver = drivers[ind]
                                DriverPhotoTile(driver: driver, extraText: ["\(vm.headWins[driver]!)", "H-H Wins"], color: getConstructorColor(constructor: displayedConstructor))
                                if (ind != drivers.count-1) { Text("vs") }
                            }
                        }
                    }
                } else {
                    Text("Loading Driver Data")
                }
            }
            //.padding()
            //.background(.tertiary.opacity(0.25))
            //.cornerRadius(25.0)
        }
        .task {
            loaded = await vm.updateData(current: true, year: "2022")
        }
        .refreshable {
            loaded = await vm.updateData(current: true, year: "2022")
        }
    }
}

struct TeammateComparisonTile_Previews: PreviewProvider {
    static var previews: some View {
        TeammateComparisonTile()
    }
}

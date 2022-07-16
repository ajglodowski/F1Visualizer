//
//  TeammateComparison.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 7/4/22.
//

import SwiftUI

struct TeammateComparison: View {
    
    @ObservedObject var vm = DriverStandingsViewModel()
    
    @State var selectedView: Int = 0
    
    var body: some View {
        ScrollView {
            if (!vm.allResults.isEmpty && !vm.loading) {
                Picker("Select Comparator:", selection: $selectedView) {
                    Text("Points").tag(0)
                    Text("Head to Head").tag(1)
                    Text("Qualifying").tag(2)
                }
                .pickerStyle(.segmented)
                
                switch selectedView {
                case 0:
                    TeammateComparisonByPoints(allResults: vm.allResults)
                case 1:
                    TeammateComparisonHeadToHead()
                case 2:
                    TeammateComparisonGrid()
                default:
                    TeammateComparisonByPoints(allResults: vm.allResults)
                }
                
            } else {
                Text("Loading Data")
            }
        }
        .task {
            if (!vm.loading) {
                await vm.loadAllData()
            }
        }
        .refreshable {
            if (!vm.loading) {
                await vm.loadAllData()
            }
        }
        .navigationTitle("Driver Comparison")
    }
}

struct TeammateComparison_Previews: PreviewProvider {
    static var previews: some View {
        TeammateComparison()
    }
}

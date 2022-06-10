//
//  ContentView.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/6/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var vm = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    Image("alonso")
                }
                VStack (alignment: .center) {
                    NavigationLink(value: 1) {
                        ViewThatFits{
                            if (!vm.isFetching) {
                                CurrentDriverStandingsTile()
                                    .frame(maxHeight: 500)
                            } else {
                                Text("Pull down to refresh")
                            }
                        }
                        
                    }
                }
                    
                VStack {
                    NavigationLink(value: 2) {
                        CurrentConstructorStandingsRow()
                    }
                }
                
                VStack (alignment: .center) {
                    NavigationLink(value: 3) {
                        MostRecentRaceRow()
                            .frame(maxHeight: 500)
                    }
                        
                }
            }
            .task {
                await vm.fetchData()
            }
            .refreshable {
                //await vm.fetchData()
            }
            .navigationDestination(for: Int.self) { val in
                switch val{
                case 1:
                    CurrentDriverStandings(drivers: vm.drivers)
                case 2:
                    CurrentConstructorStandings()
                case 3:
                    RaceDetail(year: "2022", round: "1")
                default:
                    CurrentDriverStandings(drivers: vm.drivers)
                }
            }
            .navigationTitle("F1 Visualizer")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

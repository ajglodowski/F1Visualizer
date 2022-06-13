//
//  ContentView.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/6/22.
//

import SwiftUI

struct ContentView: View {
    
    //@ObservedObject var vm = ContentViewModel()
    //@ObservedObject var rdvm = RaceDataViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    Image("alonso")
                }
                VStack () {
                    NavigationLink(value: 1) {
                        CurrentDriverStandingsRow()
                            //.frame(maxHeight: 700)
                    }
                }
                    
                VStack {
                    NavigationLink(value: 2) {
                        CurrentConstructorStandingsRow()
                    }
                }
                
                VStack (alignment: .center) {
                    NavigationLink(value: 3) {
                        RaceRow(mostRecent: true)
                            //.frame(maxHeight: 500)
                    }
                        
                }
                VStack (alignment: .center) {
                    NavigationLink(value: 3) {
                        RaceRow(mostRecent: false, year:"2022", round:"1")
                            //.frame(maxHeight: 500)
                    }
                        
                }
            }
            .task {
                //await vm.fetchData()
                //await rdvm.fetchMostRecentRace()
            }
            .refreshable {
                //await vm.fetchData()
            }
            .navigationDestination(for: Int.self) { val in
                switch val{
                case 1:
                    //CurrentDriverStandings()
                    DriverDetail(driverId:"alonso")
                case 2:
                    CurrentConstructorStandings()
                case 3:
                    RaceDetail(year: "2022", round: "1")
                default:
                    //CurrentDriverStandings(drivers: vm.drivers)
                    Text("Error")
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

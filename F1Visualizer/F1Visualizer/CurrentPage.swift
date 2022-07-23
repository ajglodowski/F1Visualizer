//
//  CurrentPage.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/15/22.
//

import SwiftUI

struct CurrentPage: View {
    var body: some View {
        NavigationView {
            List {
                
                VStack (alignment: .center) {
                    NavigationLink(destination: AllRaces()) {
                        Text("All Races")
                    }
                }
                
                VStack (alignment: .center) {
                    NavigationLink(destination: RaceDetail(current: true)) {
                        RaceRow(mostRecent: true)
                            .frame(maxHeight: 500)
                    }
                }
                
                VStack {
                    StandingGraphsRow()
                }
                
                VStack {
                    NavigationLink(destination: CurrentDriverStandings()) {
                        CurrentDriverStandingsRow()
                            //.frame(maxHeight: 700)
                    }
                }
                
                VStack {
                    TeammateComparisonTile()
                }
                    
                VStack {
                    NavigationLink(destination: CurrentConstructorStandings()) {
                        CurrentConstructorStandingsRow()
                    }
                }
                
            }
            .task {
                
            }
            .refreshable {
                
            }
            .navigationTitle("Current Season")
        }
        .navigationViewStyle(.stack)
    }
}

struct CurrentPage_Previews: PreviewProvider {
    static var previews: some View {
        CurrentPage()
    }
}

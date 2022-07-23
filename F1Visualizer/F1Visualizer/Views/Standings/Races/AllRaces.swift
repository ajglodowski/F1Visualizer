//
//  AllRaces.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 7/22/22.
//

import SwiftUI

struct AllRaces: View {
    
    @State var selectedView = 0
    
    var body: some View {
        VStack (alignment: .leading){
            Picker("Race Selection", selection: $selectedView) {
                Text("Racetable").tag(0)
                Text("All Races").tag(1)
            }
            .pickerStyle(.segmented)
            //.padding()
            ScrollView {
                switch selectedView {
                case 0:
                    RaceResultsTable()
                case 1:
                    RaceRows()
                default:
                    RaceResultsTable()
                }
            }
            
        }
        .padding()
        .navigationTitle("All Races")
    }
}

struct AllRaces_Previews: PreviewProvider {
    static var previews: some View {
        AllRaces()
    }
}

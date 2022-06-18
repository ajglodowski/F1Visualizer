//
//  StandingGraphsRow.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/15/22.
//

import SwiftUI

struct StandingGraphsRow: View {
    
    @State var selectedStanding = 0
    
    var body: some View {
        VStack (alignment: .leading){
            Text("Current Standings Visualized")
                .font(.title)
                .bold()
            Picker("Standing Selection", selection: $selectedStanding) {
                Text("Driver Standings").tag(0)
                Text("Constructor Standings").tag(1)
            }
            .pickerStyle(.segmented)
            //.padding()
            
            switch selectedStanding {
            case 0:
                DriverStandingGraph()
            case 1:
                ConstructorStandingGraph()
            default:
                DriverStandingGraph()
            }
            
        }
    }
}

struct StandingGraphsRow_Previews: PreviewProvider {
    static var previews: some View {
        StandingGraphsRow()
    }
}

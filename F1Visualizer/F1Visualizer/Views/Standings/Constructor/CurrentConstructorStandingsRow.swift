//
//  CurrentConstructorStandingsTile.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/8/22.
//

import SwiftUI

struct CurrentConstructorStandingsRow: View {
    @ObservedObject var cdvm = ConstructorDataViewModel()
        
    var body: some View {
        VStack (alignment:.leading) {
            Text("Current Constructor Standings")
                .font(.title)
                .bold()
            if (!cdvm.constructors.isEmpty) {
                ScrollView(.horizontal){
                    HStack {
                        ForEach (0..<cdvm.constructors.count) { ind in
                            ConstructorTile(constructor: cdvm.constructors[ind], extraText: String(ind+1))
                                .frame(maxHeight:300)
                        }
                    }
                }
            } else {
                Text("Loading")
            }
        }
        .padding()
        .task {
            await cdvm.fetchData()
        }
    }
}

struct CurrentConstructorStandingsRow_Previews: PreviewProvider {
    static var previews: some View {
        CurrentConstructorStandingsRow()
    }
}

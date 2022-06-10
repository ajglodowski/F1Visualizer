//
//  CurrentConstructorStandings.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/8/22.
//

import SwiftUI

struct CurrentConstructorStandings: View {
    
    @ObservedObject var cdvm = ConstructorDataViewModel()
    
    var body: some View {
        Text("Hello World")
    }
}

struct CurrentConstructorStandings_Previews: PreviewProvider {
    static var previews: some View {
        CurrentConstructorStandings()
    }
}

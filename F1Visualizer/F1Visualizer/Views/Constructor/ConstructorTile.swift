//
//  ConstructorTile.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/10/22.
//

import SwiftUI

struct ConstructorTile: View {
    
    var constructor: Constructor
    var extraText: String?
    var color: Color?
    
    var body: some View {
        VStack {
            Image(constructor.name)
                .resizable()
                .scaledToFit()
                //.frame(width:75, height: 75)
            Text(constructor.name)
            if (extraText != nil) {
                Text(extraText!)
                    .font(.title)
            }
                
        }
        .padding(6)
        .background(color ?? Color(uiColor: .tertiarySystemFill))
        .cornerRadius(20)
        
    }
}

struct ConstructorTile_Previews: PreviewProvider {
    static var previews: some View {
        let ferrari = Constructor(constructorId: "ferrari", url: "", name: "ferrari", nationality: "Italian")
        ConstructorTile(constructor: ferrari)
    }
}

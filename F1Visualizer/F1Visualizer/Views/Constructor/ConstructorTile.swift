//
//  ConstructorTile.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/10/22.
//

import SwiftUI

struct ConstructorTile: View {
    
    var constructor: Constructor
    var extraText: [String]?
    var color: Color?
    
    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [color ?? .white, .black]), startPoint: .top, endPoint: .bottom)
                .overlay {
                    VStack {
                        Image(constructor.name.lowercased())
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(20)
                            .padding()
                        //.frame(width:75, height: 75)
                        VStack {
                            Text(constructor.name)
                                .font(.title)
                                .bold()
                            if (extraText != nil) {
                                VStack {
                                    ForEach (0..<extraText!.count) { ind in
                                        Text(extraText![ind])
                                            .font(.title)
                                    }
                                }
                            }
                        }
                    }
                    .foregroundColor(.white)
                }
        }
        .cornerRadius(20)
        
        //.padding(6)
        //.background(getConstructorColor(constructor: constructor))
        //.tint(getConstructorColor(constructor: constructor))
        //.background(color ?? getConstructorColor(constructor: constructor))
        
        
    }
}

struct ConstructorTile_Previews: PreviewProvider {
    static var previews: some View {
        let ferrari = Constructor(constructorId: "ferrari", url: "", name: "ferrari", nationality: "Italian")
        ConstructorTile(constructor: ferrari, extraText: ["first line", "second line"])
    }
}

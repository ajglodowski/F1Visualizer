//
//  Constructor.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/7/22.
//

import Foundation
import SwiftUI

struct Constructor: Hashable, Identifiable, Codable {
    var constructorId: String
    var url: String
    var name: String
    var nationality: String
    
    var id: String { constructorId }
}

func getConstructorColor(constructor: Constructor) -> Color {
    switch constructor.name.lowercased() {
    case "alfa romeo":
        return Color(red: 144/255, green: 0, blue: 0)
    case "alphatauri":
        return Color(red: 43/255, green: 69/255, blue: 98/255)
    case "alpine f1 team":
        return Color(red: 34/255, green: 147/255, blue: 209/255)
    case "aston martin":
        return Color(red: 0, green: 111/255, blue: 98/255)
    case "ferrari":
        return Color(red: 220/255, green: 1/255, blue: 1/255)
    case "haas f1 team":
        return Color(red: 182/255, green: 186/255, blue: 189/255)
    case "mclaren":
        return Color(red: 255/255, green: 135/255, blue: 0)
    case "mercedes":
        return Color(red: 108/255, green: 211/255, blue: 191/255)
    case "red bull":
        return Color(red: 30/255, green: 91/255, blue: 198/255)
    case "williams":
        return Color(red: 55/255, green: 190/255, blue: 221/255)
    case "racing point":
        return Color(red: 245/255, green: 150/255, blue: 200/255)
    case "toro rosso":
         return Color(red: 70/255, green: 155/255, blue: 255/255)
    case "force india":
         return Color(red: 245/255, green: 150/255, blue: 200/255)
    case "renault":
         return Color(red: 255/255, green: 245/255, blue: 0/255)
    case "sauber":
         return Color(red: 155/255, green: 0/255, blue: 0/255)
    default:
        return Color(.white)
    }
    return Color(.blue)
}

//
//  HelperFunctions.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/8/22.
//

import Foundation

func getFlag(nationality: String) -> String {
    switch nationality {
    case "Spanish", "Spain":
        return "🇪🇸"
    case "British", "Great Brittain":
        return "🇬🇧"
    case "German", "Germany":
        return "🇩🇪"
    case "French", "France":
        return "🇫🇷"
    case "Canadian", "Canada":
        return "🇨🇦"
    case "Dutch", "Netherlands":
        return "🇳🇱"
    case "Monegasque", "Monaco":
        return "🇲🇨"
    case "Mexican", "Mexico":
        return "🇲🇽"
    case "Finnish", "Finland":
        return "🇫🇮"
    case "Danish", "Denmark":
        return "🇩🇰"
    case "Australian", "Australia":
        return "🇦🇺"
    case "Thai", "Thailand":
        return "🇹🇭"
    case "Japanese", "Japan":
        return "🇯🇵"
    case "Chinese", "China":
        return "🇨🇳"
    case "Italian", "Italy":
        return "🇮🇹"
    case "Austrian", "Austria":
        return "🇦🇹"
    default:
        return ""
    }
}

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
    case "Azerbaijani","Azerbaijan":
        return "🇦🇿"
    default:
        return ""
    }
}

func generateConstructorList(races: [Race]) -> String {
    var cons = [Constructor]()
    var output = "Constructors: "
    for race in races {
        if (!cons.contains(race.Results.first!.Constructor)) {
            cons.append(race.Results.first!.Constructor)
            output += (race.Results.first!.Constructor.name + ", ")
        }
    }
    output = String(output.dropLast(2))
    return output
}

func generateRaceWins(races: [Race]) -> [Race] {
    return []
}

func generateBestResult(races: [Race]) -> Race {
    var bestRace = races.first!
    for race in races.sorted{ $0.season > $1.season} {
        if (Int(race.Results.first!.position)! < Int(bestRace.Results.first!.position)!) {
            bestRace = race
        }
    }
    return bestRace
}

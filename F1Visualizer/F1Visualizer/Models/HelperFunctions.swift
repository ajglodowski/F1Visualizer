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
    case "British", "Great Brittain", "UK":
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
    case "American", "United States", "US", "USA":
        return "🇺🇸"
    case "Saudi", "Saudi Arabia":
        return "🇸🇦"
    case "Emirati", "United Arab Emirates":
        return "🇦🇪"
    case "Belgian", "Belgium":
        return "🇧🇪"
    case "Bahrani", "Bahrain":
        return "🇧🇭"
    case "Singaporean", "Singapore":
        return "🇸🇬"
    case "Russian", "Russia":
        return "🇷🇺"
    case "Hungarian", "Hungary":
        return "🇭🇺"
    case "Brazilian", "Brazil":
        return "🇧🇷"
    default:
        return ""
    }
}

func generateConstructorList(races: [Race]) -> String {
    var cons = [Constructor]()
    var output = ""
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
    var wins = [Race]()
    for race in (races) {
        if (race.Results.first!.position == "1") {
            wins.append(race)
        }
    }
    return wins
}

func generateBestResult(races: [Race]) -> Race {
    var bestRace = races.first!
    for race in races.sorted(by: { $0.season > $1.season}) {
        if (Int(race.Results.first!.position)! < Int(bestRace.Results.first!.position)!) {
            bestRace = race
        }
    }
    return bestRace
}

// Returns most recent race of the given non-null race array
func getMostRecentRace(races: [Race]) -> Race? {
    if (races.isEmpty) { return nil }
    var mostRecentRace = races.first!
    for ind in (0...races.count-1) {
        if (Int(races[ind].season)! > Int(mostRecentRace.season)! && Int(races[ind].round)! > Int(mostRecentRace.round)!) {
            mostRecentRace = races[ind]
        }
    }
    return mostRecentRace
}

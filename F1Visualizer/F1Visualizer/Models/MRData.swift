//
//  StandingsTable.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/7/22.
//

import Foundation

struct apiResponse: Codable {
    var MRData: MRData
}

struct MRData: Codable {
    var xmlns: String
    var series: String
    var url: String
    var limit: String
    var offset: String
    var total: String
    var StandingsTable: StandingsTable?
    var SeasonTable: SeasonTable?
    var RaceTable: RaceTable?
}

struct StandingsTable: Codable {
    var season: String
    var round: String?
    var StandingsLists: [StandingList]
}

struct StandingList: Codable {
    var season: String
    var round: String?
    var DriverStandings: [StandingItem]?
    var ConstructorsStandings: [StandingItem]?
}

struct StandingItem: Codable {
    var position: String
    var positionText: String
    var points: String
    var wins: String
    var Driver: Driver?
    var Constructor: Constructor?
    var Constructors: [Constructor]?
}

struct SeasonTable: Codable {
    var driverId: String
    var driverStandings: String
    var Seasons: [Season]
}

struct Season: Codable {
    var season: String
    var url: String
}

struct RaceTable: Codable {
    var driverId: String?
    var position: String?
    var season: String
    var round: String
    var Races: [Race]
}

struct Race: Codable {
    var season: String
    var round: String
    var url: String
    var raceName: String
    var date: String
    var Results: [Result]
    var Circuit: Circuit
}

struct Circuit: Codable {
    var circuitId: String
    var url: String
    var circuitName: String
    var Location: Location
}

struct Location: Codable {
    var lat: String
    var long: String
    var locality: String
    var country: String
}

struct Result: Codable {
    var Driver: Driver
    var Constructor: Constructor
    var number: String
    var position: String
    var positionText: String
    var points: String
    var grid: String
    var laps: String
    var status: String
    var Time: Time?
    var FastestLap: FastestLap
}

struct Time: Codable {
    var millis: String?
    var time: String
}

struct FastestLap: Codable {
    var rank: String
    var lap: String
    var Time: Time
    var AverageSpeed: AverageSpeed
}

struct AverageSpeed: Codable {
    var units: String
    var speed: String
}

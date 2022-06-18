//
//  DriverDataViewModel.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/7/22.
//

import Foundation
import Swift
import SwiftUI

class DriverDataViewModel: ObservableObject {

    @Published var driver: Driver?
    @Published var championshipWinTotal = ""
    @Published var raceWinTotal = ""
    @Published var poduimFinishes = ""
    @Published var allRaces = [Race]()
    @Published var loading = false
    @Published var mostRecentConstructor: Constructor?
    @Published var mostRecentRace: Race?
    
    
    @MainActor
    func loadAllData(driverId: String) async {
        self.loading = true
        await fetchDriverInfo(driverId: driverId)
        await fetchDriverChampionShipWins(driverId: driverId)
        self.allRaces = await fetchAllRaces(driverId: driverId)
        self.raceWinTotal = await getRaceWins()
        self.poduimFinishes = await getPodiumFinishes()
        self.mostRecentRace = getMostRecentRace(races: self.allRaces)
        self.mostRecentConstructor = mostRecentRace!.Results.first!.Constructor
        self.loading = false
    }
    
    func fetchDriverInfo(driverId: String) async {
        do {
            print("at fetch start")
            let s = "https://ergast.com/api/f1/drivers/"+driverId+".json"
            //print(s)
            guard let url = URL(string: s) else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedResponse = try JSONDecoder().decode(apiResponse.self, from: data)
            //print(decodedResponse)
            self.driver =  decodedResponse.MRData.DriverTable?.Drivers.first
            //print(self.driver)
        } catch {
            print("Failed to reach endpoint: \(error)")
        }
    }
    
    func fetchDriverChampionShipWins(driverId: String) async{
        do {
            let s = "https://ergast.com/api/f1/drivers/"+driverId+"/driverStandings/1/seasons.json"
            //print(s)
            guard let url = URL(string: s) else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedResponse = try JSONDecoder().decode(apiResponse.self, from: data)
            self.championshipWinTotal =  decodedResponse.MRData.total
        } catch {
            print("Failed to reach endpoint: \(error)")
        }
    }
    
    func fetchDriverFinishesAtPosition(driverId: String, position: String) async -> [Race] {
        do {
            //let s = "https://ergast.com/api/f1/drivers/"+driverId+"/driverStandings/"+position+"/seasons.json"
            let s = "https://ergast.com/api/f1/drivers/"+driverId+"/results/"+position+".json?limit=999"
            //print(s)
            guard let url = URL(string: s) else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedResponse = try JSONDecoder().decode(apiResponse.self, from: data)
            return decodedResponse.MRData.RaceTable?.Races ?? []
        } catch {
            print("Failed to reach endpoint: \(error)")
            return []
            //print("Failed to reach endpoint: \(error)")
        }
    }
    
    // Both of these work but are deprecated because they do additional fetches
    /*
    func getRaceWins(driverId: String) async {
        let races = await fetchDriverFinishesAtPosition(driverId: driverId, position: "1")
        print(races)
        self.raceWinTotal =  String(races.count)
    }
    
    func getPodiumFinishes(driverId: String) async {
        var total = 0
        for num in 1...4 {
            //print("Finding posii")
            let s = await fetchDriverFinishesAtPosition(driverId: driverId, position: String(num))
            //print(s)
            total += s.count
        }
        self.poduimFinishes = String(total)
    }
     */
    
    // New Driver Functions
    func fetchAllRaces(driverId: String) async -> [Race] {
        var tempRaces = [Race]()
        for p in 1...27 {
            async let tempAdd = fetchDriverFinishesAtPosition(driverId: driverId, position: String(p))
            await tempRaces += tempAdd
            //tempRaces += await fetchDriverFinishesAtPosition(driverId: driverId, position: String(p))
        }
        return tempRaces
    }
    
    func getRaceWins() async -> String {
        return String(self.allRaces.filter{ $0.Results.first!.position == "1"}.count)
    }
    
    func getPodiumFinishes() async -> String {
        return String(self.allRaces.filter{ $0.Results.first!.position == "1" || $0.Results.first!.position == "2" || $0.Results.first!.position == "3"}.count)
    }
    
    

}


//
//  DriverStandingsViewModel.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/15/22.
//

import Foundation

class DriverStandingsViewModel: ObservableObject {
    
    @Published var allResults = [StandingList]()
    @Published var year = ""
    
    @MainActor
    func loadAllData() async {
        self.allResults = await collectAllStandings()
    }
    
    func fetchSpecificStandings(year: String, round: String) async -> StandingList? {
        do {
            let s = "https://ergast.com/api/f1/"+year+"/"+round+"/driverStandings.json"
            //print(s)
            guard let url = URL(string: s) else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedResponse = try JSONDecoder().decode(apiResponse.self, from: data)
            //print(decodedResponse)
            return decodedResponse.MRData.StandingsTable!.StandingsLists.first!
        } catch {
            print("Failed to reach endpoint: \(error)")
            return nil
        }
    }
    
    func currentDriverStandings() async -> StandingList? {
        do {
            let s = "https://ergast.com/api/f1/current/DriverStandings.json"
            //print(s)
            guard let url = URL(string: s) else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedResponse = try JSONDecoder().decode(apiResponse.self, from: data)
            //print(decodedResponse)
            return decodedResponse.MRData.StandingsTable!.StandingsLists.first!
        } catch {
            print("Failed to reach endpoint: \(error)")
            return nil
        }
    }
    
    func collectAllStandings() async -> [StandingList] {
        var tempResults = [StandingList]()
        let mostRecentStandings = await currentDriverStandings()!
        self.year = mostRecentStandings.season
        for round in (1...(Int(mostRecentStandings.round!)!-1)) {
            tempResults.append(await fetchSpecificStandings(year: mostRecentStandings.season, round: String(round))!)
        }
        tempResults.append(mostRecentStandings)
        return tempResults
    }
}

//
//  RaceDataViewModel.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/8/22.
//

import Foundation
class RaceDataViewModel: ObservableObject {
    @Published var isFetching = false
    @Published var rawRaceResult: RaceTable? = nil
    @Published var drivers = [Driver]()
    
    @MainActor
    func fetchRace(year: String, round: String, current: Bool?) async {
        do {
            isFetching = true
            let url: URL
            if (!(current ?? false)) {
                url = URL(string: "https://ergast.com/api/f1/"+year+"/"+round+"/results.json")!
            } else {
                url = URL(string: "https://ergast.com/api/f1/current/last/results.json")!
            }
            print("Fetching: "+url.absoluteString)
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedResponse = try JSONDecoder().decode(apiResponse.self, from: data)
            print("Decoded Response: ")
            let result =  decodedResponse.MRData.RaceTable!
            rawRaceResult = result
            isFetching = false
        } catch {
            isFetching = false
            print("Failed to reach endpoint: \(error)")
            //fatalError("Error in race data")
        }
    }
    
    func extractDrivers() async {
        var tempDrivers = [Driver]()
        for part in (rawRaceResult?.Races[0].Results) ?? [] {
            tempDrivers.append(part.Driver)
        }
        drivers = tempDrivers
    }
    
    func fetchMostRecentRace() async {
        await fetchRace(year: "", round: "", current: true)
        await extractDrivers()
    }
    
    func fetchAll(year: String, round: String) async {
        await fetchRace(year: year, round: round, current: false)
        await extractDrivers()
        print(drivers[0].nationality)
    }
    
    
    
}

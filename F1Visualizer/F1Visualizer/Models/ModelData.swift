//
//  ModelData.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/6/22.
//

import Foundation

final class ModelData : ObservableObject {
    @Published var currentSeasonDrivers: [Driver] = []
    //@Published var currentDriversStandings: [StandingItem] = []
    
    init() {
        
    }
    
    /*
    func getCurrentDriversStandings() async throws -> [StandingItem] {
        print("Here")
        guard let url = URL(string: "https://ergast.com/api/f1/current/driverStandings.json") else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        let decodedResponse = try JSONDecoder().decode(MRData.self, from: data)
        
        print(decodedResponse)
        
        return decodedResponse.StandingsTable.StandingsLists.first?.DriverStandings ?? []
    }
     */
    
}

/*
func sampleDriverData() -> [Driver] {
    /*
    var output: [Driver] = []
    let sampleDriver1 = Driver(firstName: "Charles", lastName: "Leclerc", currentTeam: "Ferrari");
    let sampleDriver2 = Driver(firstName: "Max", lastName: "Verstappen", currentTeam: "Red Bull");
    output.append(sampleDriver1)
    output.append(sampleDriver2)
    return output
     */
}
 */



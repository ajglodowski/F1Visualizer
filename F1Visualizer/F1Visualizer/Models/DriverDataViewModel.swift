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

    @Published var championshipWinTotal = ""
    @Published var raceWinTotal = ""
    @Published var poduimFinishes = ""
    
    @MainActor
    func loadAllData(driverId: String) async {
        await fetchDriverChampionShipWins(driverId: driverId)
        await getRaceWins(driverId: driverId)
        await getPodiumFinishes(driverId: driverId)
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
            championshipWinTotal =  decodedResponse.MRData.total
        } catch {
            print("Failed to reach endpoint: \(error)")
        }
    }
    
    func fetchDriverFinishesAtPosition(driverId: String, position: String) async -> String {
        do {
            //let s = "https://ergast.com/api/f1/drivers/"+driverId+"/driverStandings/"+position+"/seasons.json"
            let s = "https://ergast.com/api/f1/drivers/"+driverId+"/results/"+position+".json"
            //print(s)
            guard let url = URL(string: s) else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedResponse = try JSONDecoder().decode(apiResponse.self, from: data)
            return decodedResponse.MRData.total
        } catch {
            return ("Failed to reach endpoint: \(error)")
            //print("Failed to reach endpoint: \(error)")
        }
    }
    
    func getRaceWins(driverId: String) async {
        raceWinTotal = await fetchDriverFinishesAtPosition(driverId: driverId, position: "1")
    }
    
    func getPodiumFinishes(driverId: String) async {
        var total = 0
        for num in 1...4 {
            let s = await fetchDriverFinishesAtPosition(driverId: driverId, position: String(num))
            //print(s)
            total += Int(s)!
        }
        poduimFinishes = String(total)
    }

}


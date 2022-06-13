//
//  ConstructorsDataViewModel.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/10/22.
//

import Foundation
import Swift
import SwiftUI

class ConstructorDataViewModel: ObservableObject {

    @Published var isFetching = false
    @Published var constructors = [Constructor]()
    @Published var standings = [StandingItem]()
    //@Published var rawStandingTable: StandingsTable? = nil

    @Published var errorMessage = ""

    // 1
    @MainActor
    func fetchData() async {
        do {
            isFetching = true
            var tempConst = [Constructor]()
            guard let url = URL(string: "https://ergast.com/api/f1/current/constructorStandings.json") else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedResponse = try JSONDecoder().decode(apiResponse.self, from: data)
            let fetchedStandings =  decodedResponse.MRData.StandingsTable!.StandingsLists.first?.ConstructorStandings ?? []
            var s = [StandingItem]()
            for standing in fetchedStandings {
                s.append(standing)
                tempConst.append(standing.Constructor!)
            }
            constructors = tempConst
            standings = s
            isFetching = false
        } catch {
            isFetching = false
            print("Failed to reach endpoint: \(error)")
        }
    }

}

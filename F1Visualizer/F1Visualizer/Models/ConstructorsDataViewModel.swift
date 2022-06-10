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

    @Published var errorMessage = ""

    // 1
    @MainActor
    func fetchData() async {
        do {
            var tempConst = [Constructor]()
            isFetching = true
            guard let url = URL(string: "https://ergast.com/api/f1/current/constructorStandings.json") else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedResponse = try JSONDecoder().decode(apiResponse.self, from: data)
            let standings =  decodedResponse.MRData.StandingsTable!.StandingsLists.first?.ConstructorsStandings ?? []
            for standing in standings {
                tempConst.append(standing.Constructor!)
            }
            constructors = tempConst
            isFetching = false
        } catch {
            isFetching = false
            print("Failed to reach endpoint: \(error)")
        }
    }

}

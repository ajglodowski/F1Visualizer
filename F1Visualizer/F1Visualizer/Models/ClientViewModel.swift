import Swift
import SwiftUI

class ContentViewModel: ObservableObject {

    @Published var isFetching = false
    @Published var drivers = [Driver]()

    @Published var errorMessage = ""

    // 1
    @MainActor
    func fetchData() async {
        do {
            isFetching = true
            guard let url = URL(string: "https://ergast.com/api/f1/current/driverStandings.json") else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedResponse = try JSONDecoder().decode(apiResponse.self, from: data)
            let standings =  decodedResponse.MRData.StandingsTable!.StandingsLists.first?.DriverStandings ?? []
            for standing in standings {
                drivers.append(standing.Driver!)
            }
            isFetching = false
        } catch {
            isFetching = false
            print("Failed to reach endpoint: \(error)")
        }
    }

}

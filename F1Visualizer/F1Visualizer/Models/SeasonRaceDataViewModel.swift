//
//  SeasonRaceDataViewModel.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 7/4/22.
//

import Foundation

class SeasonRaceDataViewModel: ObservableObject {
    
    let rdvm = RaceDataViewModel()
    @Published var loading = false;
    @Published var allResults = [RaceTable]()
    @Published var drivers: [Driver] = []
    @Published var driverTeams = [Driver: Constructor]()
    @Published var driverPairs = [Constructor: [Driver]]()
    @Published var constructors: [Constructor] = []
    @Published var points = [Driver:Int]()
    @Published var raceCount = [Driver:Int]()
    @Published var wins = [Driver:Int]()
    @Published var podiums = [Driver:Int]()
    @Published var dnfCount = [Driver:Int]()
    @Published var avgResults = [Driver: Float]()
    @Published var avgPos = [Driver: Float]()
    @Published var headWins = [Driver: Int]()
    @Published var avgGrid = [Driver: Float]()
    @Published var gridHeadWins = [Driver: Int]()
    
    
    func fetchYear(year: String) async -> [RaceTable] {
        var output = [RaceTable]()
        var rounds: Int = 0
        do { // Fetching Number of rounds
            let s = "https://ergast.com/api/f1/"+year+"/results/1.json"
            //print(s)
            guard let url = URL(string: s) else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedResponse = try JSONDecoder().decode(apiResponse.self, from: data)
            rounds = Int(decodedResponse.MRData.total)!
        } catch {
            print("Failed to reach endpoint: \(error)")
        }
        
        for round in (1...rounds) { // Getting all the race tables
            if (!rdvm.isFetching) {
                let adding = await rdvm.fetchRace(year: year, round: String(round), current: false)!
                output.append(adding)
            }
        }
        return output
    }
    
    func getDrivers() -> [Driver] {
        var output: [Driver] = []
        for race in self.allResults {
            for driver in race.Races.first!.Results {
                if (!output.contains(driver.Driver)) {
                    output.append(driver.Driver)
                }
            }
        }
        return output
    }
    
    func getDriverTeams() -> [Driver:Constructor] {
        var output = [Driver:Constructor]()
        for race in self.allResults {
            for driver in race.Races.first!.Results {
                if (output[driver.Driver] == nil) {
                    output[driver.Driver] = driver.Constructor
                }
            }
        }
        return output
    }
    
    func getDriverPairs() -> [Constructor: [Driver]] {
        var output = [Constructor: [Driver]]()
        for race in self.allResults {
            let result = race.Races.first!.Results
            for driver in result {
                if (output[driver.Constructor] == nil) {
                    output[driver.Constructor] = [driver.Driver]
                } else {
                    if (!output[driver.Constructor]!.contains(driver.Driver)) {
                        output[driver.Constructor]!.append(driver.Driver)
                    }
                }
            }
        }
        return output
    }
    
    func getConstructors() -> [Constructor] {
        return self.driverPairs.keys.map { $0 }
    }
    
    func getPoints() -> [Driver: Int] {
        var sum = [Driver: Int]()
        for race in self.allResults {
            for driver in race.Races.first!.Results {
                if (sum[driver.Driver] == nil) {
                    sum[driver.Driver] = Int(driver.points)
                } else {
                    sum[driver.Driver]! += Int(driver.points)!
                }
            }
        }
        return sum
    }
    
    func getRaceCount() -> [Driver: Int] {
        var total = [Driver: Int]()
        for race in self.allResults {
            for driver in race.Races.first!.Results {
                if (total[driver.Driver] == nil) {
                    total[driver.Driver] = 1
                } else {
                    total[driver.Driver]! += 1
                }
            }
        }
        return total
    }
    
    func getAvgResults() -> [Driver: Float] {
        var output = [Driver: Float]()
        for d in self.drivers {
            output[d] = Float(self.points[d]!) / Float(self.raceCount[d]!)
        }
        return output
    }
    
    func getAvgPos() -> [Driver: Float] {
        var sum = [Driver: Int]()
        for race in self.allResults {
            for driver in race.Races.first!.Results {
                if (sum[driver.Driver] == nil) {
                    sum[driver.Driver] = Int(driver.position)
                } else {
                    sum[driver.Driver]! += Int(driver.position)!
                }
            }
        }
        var output = [Driver: Float]()
        for d in self.drivers {
            output[d] = Float(sum[d]!) / Float(self.raceCount[d]!)
        }
        return output
    }
    
    func getWins() -> [Driver: Int] {
        var total = [Driver: Int]()
        for d in self.drivers {
            total[d] = 0
        }
        for race in self.allResults {
            let r = race.Races.first!.Results.first!
            let driver = r.Driver
            total[driver]! += 1
        }
        return total
    }
    
    func getPodiums() -> [Driver: Int] {
        var total = [Driver: Int]()
        for d in self.drivers {
            total[d] = 0
        }
        for race in self.allResults {
            let result = race.Races.first!.Results.filter {Int($0.position)! < 4}
            for driver in result {
                total[driver.Driver]! += 1
            }
        }
        return total
    }
    
    func getDnfCount() -> [Driver: Int] {
        var total = [Driver: Int]()
        for d in self.drivers {
            total[d] = 0
        }
        for race in self.allResults {
            for driver in race.Races.first!.Results {
                if (driver.status != "Finished" && !driver.status.contains("+")) {
                    total[driver.Driver]! += 1
                }
            }
        }
        return total
    }
    
    func getHeadWins() -> [Driver: Int] {
        var output = [Driver: Int]()
        for race in self.allResults {
            var headWinners = [Constructor: Driver]() // Dict to hold head to head winners
            let result = race.Races.first!.Results
            for driver in result {
                if (output[driver.Driver] == nil) { output[driver.Driver] = 0 } // Init driver in out dictionary
                if headWinners[driver.Constructor] == nil {
                    output[driver.Driver]! += 1
                    headWinners[driver.Constructor] = driver.Driver
                }
            }
        }
        //print(output)
        return output
    }
    
    func getAvgGrid() -> [Driver: Float] {
        var sum = [Driver: Int]()
        var total = [Driver: Int]()
        for race in self.allResults {
            for driver in race.Races.first!.Results {
                var grid = driver.grid
                if (grid == "0") { grid = "20" }
                if (sum[driver.Driver] == nil) {
                    sum[driver.Driver] = Int(grid)
                    total[driver.Driver] = 1
                } else {
                    sum[driver.Driver]! += Int(grid)!
                    total[driver.Driver]! += 1
                }
            }
        }
        var output = [Driver: Float]()
        for d in self.drivers {
            output[d] = Float(sum[d]!) / Float(total[d]!)
        }
        return output
    }
    
    func getGridHeadWins() -> [Driver: Int] {
        var output = [Driver: Int]()
        var constructors: [Constructor] = []
        for race in self.allResults {
            var headWinners = [Constructor: Driver]() // Dict to hold head to head winners
            var gridSpot = [Constructor: Int]() // Dict to hold head to head winners
            let result = race.Races.first!.Results
            for driver in result {
                if (!constructors.contains(driver.Constructor)) { constructors.append(driver.Constructor) }
                if (output[driver.Driver] == nil) { output[driver.Driver] = 0 } // Init driver in out dictionary
                if headWinners[driver.Constructor] == nil {
                    headWinners[driver.Constructor] = driver.Driver
                    gridSpot[driver.Constructor] = Int(driver.grid)
                } else {
                    if (Int(driver.grid)! < gridSpot[driver.Constructor]!) {
                        headWinners[driver.Constructor] = driver.Driver
                        gridSpot[driver.Constructor] = Int(driver.grid)
                    }
                }
            }
            
            for c in constructors {
                output[headWinners[c]!]! += 1
            }
        }
        return output
    }
    
    @MainActor
    func updateData(current: Bool, year: String?) async -> Bool {
        if (current) {
            self.loading = true
            self.allResults = await fetchYear(year: "2022")
            self.drivers = getDrivers()
            self.driverTeams = getDriverTeams()
            self.driverPairs = getDriverPairs()
            self.constructors = getConstructors()
            self.points = getPoints()
            self.raceCount = getRaceCount()
            self.podiums = getPodiums()
            self.dnfCount = getDnfCount()
            self.avgResults = getAvgResults()
            self.avgPos = getAvgPos()
            self.headWins = getHeadWins()
            self.avgGrid = getAvgGrid()
            self.gridHeadWins = getGridHeadWins()
            self.loading = false
            return true
        } else {
            self.loading = true
            self.allResults = await fetchYear(year: year!)
            self.drivers = getDrivers()
            self.driverTeams = getDriverTeams()
            self.driverPairs = getDriverPairs()
            self.constructors = getConstructors()
            self.points = getPoints()
            self.raceCount = getRaceCount()
            self.avgResults = getAvgResults()
            self.avgPos = getAvgPos()
            self.headWins = getHeadWins()
            self.avgGrid = getAvgGrid()
            self.gridHeadWins = getGridHeadWins()
            self.loading = false
            return true
        }
    }
    
}

//
//  DriverStandingGraph.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/15/22.
//

import SwiftUI
import Charts

struct DriverStandingGraph: View {
    
    @ObservedObject var vm = DriverStandingsViewModel()
    
    @State var selectedGraph = 0
    
    struct driverPointsCount: Identifiable {
        var id = UUID()
        var driver: Driver
        var season: String
        var round: Int
        var points: Int
        var position: Int
    }
    
    struct driverSeries: Identifiable {
        let driver: Driver
        let points: [driverPointsCount]
        var id = UUID()
    }
    
    var pointsCounts: [driverPointsCount] {
        var output = [driverPointsCount]()
        if (!vm.allResults.isEmpty) {
            for result in vm.allResults {
                for d in result.DriverStandings! {
                    let adding = driverPointsCount(driver: d.Driver!, season: result.season, round: Int(result.round!)!, points: Int(d.points)!, position: Int(d.position)!)
                    output.append(adding)
                }
            }
            return output
        } else { return output }
    }
    
    var seriesCounts: [driverSeries] {
        if (!pointsCounts.isEmpty) {
            //print(" ")
            var output = [driverSeries]()
            for driver in Array(Set(pointsCounts.map{ $0.driver})) {
                //print(driver.driverId)
                var seriesAr = [driverPointsCount]()
                seriesAr += pointsCounts.filter { $0.driver == driver}
                //print(seriesAr.count)
                let adding = driverSeries(driver: driver, points: seriesAr)
                output.append(adding)
            }
            //print(output.count)
            return output
        } else {
            return [driverSeries]()
        }
    }
    
    var top5SeriesCounts: [driverSeries] {
        if (!seriesCounts.isEmpty) {
            print(seriesCounts.count)
            let filtered = seriesCounts.filter { $0.points.last!.position < 6}
            //let filtered = seriesCounts.filter { $0.driver.driverId == "perez"}
            //print("blah")
            //print(filtered)
            print(filtered.first!.points)
            return filtered
        }
        else { return [driverSeries]() }
    }
    
    func selectedQuality(d: driverPointsCount) -> Int {
        switch selectedGraph {
        case 2:
            return d.position
        default:
            return d.points
        }
    }
    
    var selectedSeriesCounts: [driverSeries] {
        switch selectedGraph {
        case 0:
            return seriesCounts
        case 1:
            return top5SeriesCounts
        default:
            return seriesCounts
        }
    }
    
    var body: some View {
        VStack {
            if (!vm.allResults.isEmpty && !pointsCounts.isEmpty) {
                VStack {
                    HStack{
                        Text(vm.year + " Driver Standings")
                            .font(.title)
                        Picker("Driver Selection", selection: $selectedGraph) {
                            Text("All Drivers").tag(0)
                            Text("Top 5").tag(1)
                            Text("By Position").tag(2)
                        }
                        .pickerStyle(.segmented)
                    }
                    ScrollView(.horizontal) {
                        Chart() {
                            ForEach(selectedSeriesCounts) { series in
                                ForEach(series.points) { stat in
                                    LineMark(
                                        x: .value("Round", stat.round),
                                        y: .value("Values", selectedQuality(d: stat))
                                    )
                                    /*.annotation(position: .top) {
                                        Text(String(series.driver.code))
                                    }*/
                                }
                                .foregroundStyle(by: .value("Driver", series.driver.code))
                                .symbol(by: .value("Driver", series.driver.code))
                            }
                        }
                        //.interpolationMethod(.catmullRom)
                        .chartPlotStyle { plotArea in
                            plotArea.frame(height:500)
                        }
                        //.chartForegroundStyleScale(serviceColors)
                        .frame(width: 1000)
                        .padding()
                    }
                }
            } else {
                Text("Loading Graph")
            }
        }
        
        .task {
            await vm.loadAllData()
        }
        .refreshable {
            await vm.loadAllData()
        }
    }
    
}

struct DriverStandingGraph_Previews: PreviewProvider {
    static var previews: some View {
        DriverStandingGraph()
    }
}

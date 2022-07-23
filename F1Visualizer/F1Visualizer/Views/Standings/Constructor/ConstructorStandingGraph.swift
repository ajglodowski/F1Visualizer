//
//  constructorStandingGraph.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/15/22.
//

import SwiftUI
import Charts

struct ConstructorStandingGraph: View {
    
    @ObservedObject var vm = ConstructorStandingsViewModel()
    
    @State var selectedGraph = 0
    
    struct constructorPointsCount: Identifiable {
        var id = UUID()
        var constructor: Constructor
        var season: String
        var round: Int
        var points: Int
        var position: Int
    }
    
    struct constructorSeries: Identifiable {
        let constructor: Constructor
        let points: [constructorPointsCount]
        var id = UUID()
    }
    
    var pointsCounts: [constructorPointsCount] {
        var output = [constructorPointsCount]()
        if (!vm.allResults.isEmpty) {
            for result in vm.allResults {
                for d in result.ConstructorStandings! {
                    let adding = constructorPointsCount(constructor: d.Constructor!, season: result.season, round: Int(result.round!)!, points: Int(d.points)!, position: Int(d.position)!)
                    output.append(adding)
                }
            }
            return output
        } else { return output }
    }
    
    var seriesCounts: [constructorSeries] {
        if (!pointsCounts.isEmpty) {
            //print(" ")
            var output = [constructorSeries]()
            for constructor in Array(Set(pointsCounts.map{ $0.constructor})) {
                //print(constructor.constructorId)
                var seriesAr = [constructorPointsCount]()
                seriesAr += pointsCounts.filter { $0.constructor == constructor}
                //print(seriesAr.count)
                let adding = constructorSeries(constructor: constructor, points: seriesAr)
                output.append(adding)
            }
            //print(output.count)
            return output
        } else {
            return [constructorSeries]()
        }
    }
    
    var top5SeriesCounts: [constructorSeries] {
        if (!seriesCounts.isEmpty) {
            print(seriesCounts.count)
            let filtered = seriesCounts.filter { $0.points.last!.position < 6}
            //let filtered = seriesCounts.filter { $0.constructor.constructorId == "perez"}
            //print("blah")
            //print(filtered)
            print(filtered.first!.points)
            return filtered
        }
        else { return [constructorSeries]() }
    }
    
    func selectedQuality(d: constructorPointsCount) -> Int {
        switch selectedGraph {
        case 2:
            return d.position
        default:
            return d.points
        }
    }
    
    var selectedSeriesCounts: [constructorSeries] {
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
                        Text(vm.year + " Constructor Standings")
                            .font(.title)
                        Picker("Constructor Selection", selection: $selectedGraph) {
                            Text("All constructors").tag(0)
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
                                        Text(String(series.constructor.code))
                                    }*/
                                }
                                .foregroundStyle(by: .value("constructor", series.constructor.name))
                                .symbol(by: .value("constructor", series.constructor.name))
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

struct constructorStandingGraph_Previews: PreviewProvider {
    static var previews: some View {
        ConstructorStandingGraph()
    }
}

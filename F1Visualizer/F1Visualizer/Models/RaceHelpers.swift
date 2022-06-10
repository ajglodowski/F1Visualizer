//
//  RaceHelpers.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/8/22.
//

import Foundation

func getFastestTime(race: Race) -> Result? {
    for result in race.Results {
        if (result.FastestLap.rank == "1") {
            return result
        }
    }
    return nil
}

//
//  Driver.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/6/22.
//

import Foundation

struct Driver: Hashable, Identifiable, Codable {
    var driverId: String
    var permanentNumber: String
    var code: String
    var url: String
    var givenName: String
    var familyName: String
    var dateOfBirth: String
    var nationality: String
    
    var id: String { driverId }
}

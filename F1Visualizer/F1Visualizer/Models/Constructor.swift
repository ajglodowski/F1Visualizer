//
//  Constructor.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/7/22.
//

import Foundation

struct Constructor: Hashable, Identifiable, Codable {
    var constructorId: String
    var url: String
    var name: String
    var nationality: String
    
    var id: String { constructorId }
}

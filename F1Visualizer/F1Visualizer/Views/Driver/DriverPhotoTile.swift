//
//  DriverPhotoTile.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/7/22.
//

import SwiftUI

struct DriverPhotoTile: View {
    var driver: Driver
    var extraText: String?
    
    let iconShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
    
    var body: some View {
        VStack {
            Image(driver.driverId)
                .resizable()
                .scaledToFit()
                //.frame(width:75, height: 75)
            let text = driver.givenName+" "+driver.familyName
            Text(text)
            if (extraText != nil) {
                Text(extraText!)
                    .font(.title)
            }
                
        }
        .padding(6)
        #if canImport(UIKit)
        .background(Color(uiColor: .tertiarySystemFill), in: iconShape)
        #else
        .background(.quaternary.opacity(0.5), in: iconShape)
        #endif
        .overlay {
            iconShape.strokeBorder(.quaternary, lineWidth: 0.5)
        }
        
    }
}

struct DriverPhotoTile_Previews: PreviewProvider {
    static var previews: some View {
        DriverPhotoTile(driver: Driver(driverId: "alonso", permanentNumber: "1", code: "ALO", url: ".com", givenName: "Fernando", familyName: "Alonso", dateOfBirth: "10-10-2022", nationality: "Spanish"), extraText:"🥇")
    }
}

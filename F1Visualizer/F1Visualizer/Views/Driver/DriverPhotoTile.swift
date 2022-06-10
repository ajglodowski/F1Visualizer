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
    var color: Color?
    
    //let iconShape = RoundedRectangle(cornerRadius: 20, style: .continuous)
    
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
        .background(color ?? Color(uiColor: .tertiarySystemFill))
        .cornerRadius(20)
        
    }
}

struct DriverPhotoTile_Previews: PreviewProvider {
    static var previews: some View {
        DriverPhotoTile(driver: Driver(driverId: "alonso", permanentNumber: "1", code: "ALO", url: ".com", givenName: "Fernando", familyName: "Alonso", dateOfBirth: "10-10-2022", nationality: "Spanish"), extraText:"🥇")
    }
}

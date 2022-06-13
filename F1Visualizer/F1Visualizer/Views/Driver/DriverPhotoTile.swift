//
//  DriverPhotoTile.swift
//  F1Visualizer
//
//  Created by AJ Glodowski on 6/7/22.
//

import SwiftUI

struct DriverPhotoTile: View {
    var driver: Driver
    var extraText: [String]?
    var color: Color?
    
    //let iconShape = RoundedRectangle(cornerRadius: 20, style: .continuous)
    
    var body: some View {
        NavigationLink(destination: DriverDetail(driverId: driver.driverId)) {
            VStack {
                LinearGradient(gradient: Gradient(colors: [color ?? .white, .black]), startPoint: .top, endPoint: .bottom)
                    .overlay {
                        VStack(alignment: .center) {
                            Image(driver.driverId)
                                .resizable()
                                .scaledToFit()
                            //.frame(width:75, height: 75)
                            let text = driver.givenName+" "+driver.familyName
                            Text(text)
                                .font(.title)
                                .bold()
                                .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                            if (extraText != nil) {
                                VStack {
                                    ForEach (0..<extraText!.count) { ind in
                                        Text(extraText![ind])
                                            .font(.title)
                                    }
                                }
                            }
                            
                        }
                        .foregroundColor(.white)
                        //.background(color ?? LinearGradient(gradient: Gradient(colors: [.gray])))
                        //.fill
                    }
            }
            
            .cornerRadius(20)
        }
        //.padding(6)
    }
        
}

struct DriverPhotoTile_Previews: PreviewProvider {
    static var previews: some View {
        DriverPhotoTile(driver: Driver(driverId: "alonso", permanentNumber: "1", code: "ALO", url: ".com", givenName: "Fernando", familyName: "Alonso", dateOfBirth: "10-10-2022", nationality: "Spanish"), extraText:["🥇"])
    }
}

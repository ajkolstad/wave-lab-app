//
//  DWBView.swift
//  Wave Lab Management
//
//  Created by Alex Kolstad on 1/22/21.
//

import SwiftUI

struct DWBView: View {
    @State private var curFillTargetDWB: String = "3.45"
    @State private var editDWB = false
    
    @State private var lastFill: String = "4.67"
    @State private var lastFillTime: String = "11:52 PM"
    @State private var etaTime: String = "22"
    
    @State private var fillTime: String = "17"
    @State private var waterUsed: String = "69,420"
    
    
    var body: some View {
        VStack {
            VStack {
                Text("Directional Wave Basin")
                    .font(.title)
                    .padding(.bottom, 20)
                    
                }
            VStack(alignment: .leading) {
                HStack {
                    Text("Current Fill Target")
                        .font(.title2)
                    if editDWB {
                        TextField("Name", text: $curFillTargetDWB).textFieldStyle(RoundedBorderTextFieldStyle())
                            //.padding(.leading, 5)
                            .font(.title2)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                            .foregroundColor(.red)
                    } else {
                        Text(curFillTargetDWB + "m")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button(action: {
                        self.editDWB.toggle()
                            }) {
                                Text(editDWB ? "Done" : "Edit")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                    
                }.padding(.bottom, 20)
                
                HStack {
                    Text("ETA")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    Text(etaTime + "hrs")
                        .font(.title2)
                }.padding(.bottom, 20)
                
                HStack {
                    Text("Last Filled to")
                        .font(.callout)
                    Text(lastFill + "m")
                        .font(.callout)
                }.padding(.bottom, 3)
                
                Text(lastFillTime)
                    .font(.callout)
                    .foregroundColor(.gray)
                Divider()
                Image("tempGraph")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                HStack {
                    VStack (alignment: .leading) {
                        Text("Fill Time")
                            .font(.callout)
                            .foregroundColor(.blue)
                        Text(fillTime + "hrs")
                            .font(.callout)
                    }.padding(.trailing, 120)
                    VStack (alignment: .leading) {
                        Text("Water Used")
                            .font(.callout)
                            .foregroundColor(.init(red: 0.4, green: 0.8, blue: 1))
                        Text(waterUsed + " gal")
                    }
                    
                }
                
                VStack (alignment: .leading){
                    Text("Live View")
                        .font(.title2)
                    Webview(url: "https://www.youtube.com/embed/pHmmBQYVPCI?playsinline=1")
                }.padding(.top, 30)
            }
        }
    }
}

struct DWBView_Previews: PreviewProvider {
    static var previews: some View {
        DWBView()
    }
}

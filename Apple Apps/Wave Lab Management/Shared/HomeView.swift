//
//  HomeView.swift
//  Wave Lab Management
//
//  Created by Alex Kolstad on 1/22/21.
//

import SwiftUI

struct HomeView: View {
    
    @State private var LWFState: String = "Filling to 5m now                                     "
    @State private var DWBState: String = "Waiting for fill to 3.45m at 12:00AM    "
    
    @State private var LWFDepth: String = "Currently 4.3m"
    @State private var DWBDepth: String = "Currently 1.8m"
    
    let customColor : Color = Color(red: 18/255, green: 18/255, blue: 18/255)
    
    var body: some View {
        ScrollView(.vertical) {
        VStack {
            Text("Home")
                .font(.title)
                .padding(.bottom, 15)
            VStack {
                VStack {
                    Text("Large Wave Flume")
                        .font(.title2)
                }.padding(.bottom, 5).padding(.top, 5)
                VStack (alignment: .leading) {
                    Text(LWFState)
                    Text(LWFDepth)
                }.frame(width: 320).padding(.bottom, 10)
                Webview(url: "https://www.youtube.com/embed/ciioaETC6wE?playsinline=1")
                    .frame(width: 288, height: 162)
                    .padding(.bottom, 15)
            }.background(customColor).cornerRadius(15).padding(.bottom, 15)
            
            VStack {
                VStack {
                    Text("Directional Wave Basin")
                        .font(.title2)
                }.padding(.bottom, 5).padding(.top, 5)
                VStack (alignment: .leading) {
                    Text(DWBState)
                    Text(LWFDepth)
                }.frame(width: 320).padding(.bottom, 10)
                Webview(url: "https://www.youtube.com/embed/pHmmBQYVPCI?playsinline=1")
                    .frame(width: 288, height: 162)
                    .padding(.bottom, 15)
            }.background(customColor).cornerRadius(15)
            VStack (alignment: .leading){
                Text("Large Wave Flume")
                    .font(.title2)
                ScrollView(.horizontal) {
                    HStack (spacing: 20){
                        Webview(url: "https://www.youtube.com/embed/ciioaETC6wE?playsinline=1")
                            .frame(width: 384, height: 216)
                        Webview(url: "https://www.youtube.com/embed/V3JsFPQA6YQ?playsinline=1")
                            .frame(width: 384, height: 216)
                        Webview(url: "https://www.youtube.com/embed/VCluhS3RJpI?playsinline=1")
                            .frame(width: 384, height: 216)
                    }
                }.padding(.bottom, 10)
                Divider()
                Text("Directional Wave Basin")
                    .font(.title2)
                    .padding(.top, 20)
                ScrollView(.horizontal) {
                    HStack (spacing: 20){
                        Webview(url: "https://www.youtube.com/embed/pHmmBQYVPCI?playsinline=1")
                            .frame(width: 384, height: 216)
                        Webview(url: "https://www.youtube.com/embed/xNzdOP3ixd4?playsinline=1")
                            .frame(width: 384, height: 216)
                        Webview(url: "https://www.youtube.com/embed/Z7V0x92PpXU?playsinline=1")
                            .frame(width: 384, height: 216)
                    }
                }
            }
        }
    }
}
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

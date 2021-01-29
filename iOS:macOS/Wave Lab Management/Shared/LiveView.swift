//
//  LiveView.swift
//  Wave Lab Management
//
//  Created by Alex Kolstad on 1/28/21.
//

import SwiftUI

struct LiveView: View {
    var body: some View {
        VStack {
            Text("Live Views")
                .font(.title)
                .padding(.bottom, 20)
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

struct LiveView_Previews: PreviewProvider {
    static var previews: some View {
        LiveView()
    }
}

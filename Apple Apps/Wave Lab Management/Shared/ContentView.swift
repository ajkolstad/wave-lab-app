//
//  ContentView.swift
//  Shared
//
//  Created by Alex Kolstad on 1/21/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView().tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
            }
            LWFView().tabItem {
                    Image(systemName: "drop")
                    Text("LWF")
            }
            DWBView().tabItem {
                    Image(systemName: "drop.fill")
                    Text("DWB")
            }
            SettingsView().tabItem {
                    Image(systemName: "person.fill")
                    Text("User")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



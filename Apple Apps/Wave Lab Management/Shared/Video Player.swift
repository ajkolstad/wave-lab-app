//
//  Video Player.swift
//  Wave Lab Management
//
//  Created by Alex Kolstad on 1/28/21.
//

import Foundation
import SwiftUI
import WebKit

struct Webview: UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }
        
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        
        let request = URLRequest(url: url)
        let wkwebview = WKWebView(frame: CGRect(x: 0, y: 0, width: 480, height: 240), configuration: configuration)

        wkwebview.load(request)
        

        return wkwebview
    }
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<Webview>) {
    }
}

////
////  testAPI.swift
////  StocksHub
////
////  Created by Param Thakker on 4/28/22.
////
//
//import Foundation
//import SwiftUI
//
//struct Example: Codable {
//    let userId: Int
//    let id: Int
//    let title: String
//    let completed: Bool
//}
//class LatestPriceModel:ObservableObject{
//func getJson() {
//    let urlString = "https://jsonplaceholder.typicode.com/todos/1"
//    if let url = URL(string: urlString) {
//        URLSession.shared.dataTask(with: url) {data, res, err in
//            if let data = data {
//
//                let decoder = JSONDecoder()
//                do {
//                    let json: Example = try! decoder.decode(Example.self, from: data)
//                    //completion(json)
//                }catch let error {
//                    print(error.localizedDescription)
//                }
//            }
//        }.resume()
//    }
//}
//}
//
//struct ve:View{
//    @StateObject var lpModel=LatestPriceModel()
//    var body: some View{
//        List{
//
//        }.onAppear{
//            lpModel.getJson()
//        }
//    }
//}
//
//

import SwiftUI
import WebKit

struct wk: UIViewRepresentable {
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var webView: WKWebView?
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.webView = webView
        }
        
        // receive message from wkwebview
        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            print(message.body)
            let date = Date()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.messageToWebview(msg: "TSLA is the ticker name")
            }
        }
        
        func messageToWebview(msg: String) {
            self.webView?.evaluateJavaScript("webkit.messageHandlers.bridge.onMessage('\(msg)')")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let coordinator = makeCoordinator()
        let userContentController = WKUserContentController()
        userContentController.add(coordinator, name: "bridge")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let _wkwebview = WKWebView(frame: .zero, configuration: configuration)
        _wkwebview.navigationDelegate = coordinator
        
        return _wkwebview
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let path: String = Bundle.main.path(forResource: "test", ofType: "html") else { return }
        let localHTMLUrl = URL(fileURLWithPath: path, isDirectory: false)
        webView.loadFileURL(localHTMLUrl, allowingReadAccessTo: localHTMLUrl)
    }
}

struct lol: View {
    var body: some View {
        VStack {
            Text("hello?")
            wk()
        }
    }
}



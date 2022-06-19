//
//  StocksHubApp.swift
//  StocksHub
//
//  Created by Param Thakker on 4/6/22.
//

import SwiftUI

@main
struct StocksHubApp: App {
    
    var body: some Scene {
       
        WindowGroup {
            
         
            ContentView(totalCash: 25000,marketValueOfStocks:0,favoritesTickerList: [],portfolioTickerList: [])
            //DailyChart(closing: [], time: [], ticker: "as", change: 3.3)
            //mainView(strongBuyData: [], buyData: [], holdData: [], sellData: [], strongSellData: [])
            
//            EPSView()
            
            //HistData()
           // DailyView()
            
            //HistData()
            //lol()
        }
    }
    
}
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        HIChartView.preload()
//        return true
//    }
//}

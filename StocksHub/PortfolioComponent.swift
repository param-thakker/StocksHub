//
//  PortfolioComponent.swift
//  StocksHub
//
//  Created by Param Thakker on 4/28/22.
//

import Foundation
import SwiftUI


struct PortfolioComp:Hashable,Codable{
    var stockTicker:String
    var numShares:Int
    var avgPrice:Double
    var latestStockPrice:Double
    var change:Double
    var percentChange:Double
    
    
    
    
    
//    var change:Double
//    var percentChange:Double
    //var stockPrice:Double
    
    
    init(ticker:String,shares:Int, avg:Double, latestprice:Double,stockChange:Double,stockPercentChange:Double){ //,priceChange:Double,percentChange:Double, price:Double,
        self.stockTicker=ticker
        self.numShares=shares
        self.avgPrice=avg
        self.latestStockPrice=latestprice
        self.change=stockChange
        self.percentChange=stockPercentChange
        
        //self.stockPrice=price
       
//        self.change=priceChange
//        self.percentChange=percentChange
    }
}

//
//  FavoriteComponent.swift
//  StocksHub
//
//  Created by Param Thakker on 4/28/22.
//

import Foundation
import SwiftUI


struct FavoriteComp:Hashable,Codable{
    var stockTicker:String
    var stockName:String
    var stockPrice:Double
    var change:Double
    var percentChange:Double
    
    init(ticker:String,name:String,price:Double,priceChange:Double,percentChange:Double){
        self.stockTicker=ticker
        self.stockName=name
        self.stockPrice=price
        self.change=priceChange
        self.percentChange=percentChange
    }
}

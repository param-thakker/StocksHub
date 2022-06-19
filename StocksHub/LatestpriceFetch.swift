//
//  LatestpriceFetch.swift
//  StocksHub
//
//  Created by Param Thakker on 5/1/22.
//

import Foundation
import SwiftUI

struct Latestprice: Codable{
    let c:Double
    let d:Double
    let dp:Double
    let h:Double
    let l:Double
    let o:Double
    let pc:Double
    let t:Double
}


class LatestPriceModel:ObservableObject {
    @Published var currentPrice: Double=0
    @Published var change: Double=0
    @Published var changePercent: Double=0
    @Published var highPrice: Double = 0
    @Published var lowPrice: Double = 0
    @Published var openPrice: Double = 0
    @Published var prevClose: Double = 0
    @Published var time:Double=0
    @Published var isFetchingData: Bool = true
    func fetch(stockName:String) {
        guard let url=URL(string:"https://financehubbackend.wl.r.appspot.com/api/v1.0.0/latestprice/" + stockName) else{
            return
        }

        let task=URLSession.shared.dataTask(with: url){[weak self]
            data,_,error in guard let data = data, error==nil else {
                return
            }

            do{
                let lp=try JSONDecoder().decode(Latestprice.self, from: data)
                self?.currentPrice=lp.c
                self?.change=lp.d
                self?.changePercent=lp.dp
                self?.highPrice=lp.h
                self?.lowPrice=lp.l
                self?.openPrice=lp.o
                self?.prevClose=lp.pc
                self?.time=lp.t
                self?.isFetchingData=false
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}




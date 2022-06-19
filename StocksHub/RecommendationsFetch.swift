//
//  RecommendationsFetch.swift
//  StocksHub
//
//  Created by Param Thakker on 5/1/22.
//

import Foundation
import SwiftUI


struct RecommendationsData:Hashable,Codable{
        let buy:Int
        let hold:Int
        let period:String
        let sell:Int
        let strongBuy:Int
        let strongSell:Int
}

class RecommendationsModel:ObservableObject {
    @Published var results:[RecommendationsData]=[]
    @Published var strongBuyData:[Int]=[]
    @Published var buyData:[Int]=[]
    @Published var holdData:[Int]=[]
    @Published var sellData:[Int]=[]
    @Published var strongSellData:[Int]=[]
    @Published var periodData:[String]=[]
    @Published var isFetchingData: Bool = true
    func fetch(stockName:String)  {
        guard let url=URL(string:"https://financehubbackend.wl.r.appspot.com/api/v1.0.0/recommendations/" + stockName) else{
            return
        }
    
        let task=URLSession.shared.dataTask(with: url){[weak self]
            data,_,error in guard let data = data, error==nil else {
                return
            }
             
            do{
                let results=try JSONDecoder().decode([RecommendationsData].self, from: data)
                DispatchQueue.main.async {
                    self?.results=results

                    
                    for index in 0 ..< self!.results.count {
                        self!.strongBuyData.append(self!.results[index].strongBuy)
                        self!.buyData.append(self!.results[index].buy)
                        self!.holdData.append(self!.results[index].hold)
                        self!.sellData.append(self!.results[index].sell)
                        self!.strongSellData.append(self!.results[index].strongSell)
                        self!.periodData.append(self!.results[index].period)
                    }
                    self?.isFetchingData = false
                   

                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
    
}


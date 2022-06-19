//
//  DailyDataFetch.swift
//  StocksHub
//
//  Created by Param Thakker on 5/1/22.
//

import Foundation
import SwiftUI

struct DailyChartsData:Hashable,Codable{
    let c:[Double]
    let t:[Double]
}
class DailyChartsModel:ObservableObject {
    @Published var isFetchingData: Bool = true
    @Published var closingData:[Double]=[]
    @Published var timeData:[Double]=[]
    func fetch(stockName:String, time:Double)  {
//        guard let url=URL(string:"https://financehubbackend.wl.r.appspot.com/api/v1.0.0/dailycharts/" + stockName + "/date/1651685793000") else{
//            return
//        }
        let timeStamp=String(Double(time*1000))
        guard let url=URL(string:"https://financehubbackend.wl.r.appspot.com/api/v1.0.0/dailycharts/" + stockName + "/date/" + timeStamp) else{
            return
        }
        
        
        
       // 1651683711000
        
       // 1651608003000

        let task=URLSession.shared.dataTask(with: url){[weak self]
            data,_,error in guard let data = data, error==nil else {
                return
            }

            do{
                let dailyData=try JSONDecoder().decode(DailyChartsData.self, from: data)
                self?.closingData=dailyData.c
                self?.timeData=dailyData.t
                self?.isFetchingData = false
//                print(self?.closingData)
//                print(self?.timeData)

            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}

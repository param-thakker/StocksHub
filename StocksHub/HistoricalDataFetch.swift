//
//  HistoricalDataFetch.swift
//  StocksHub
//
//  Created by Param Thakker on 5/1/22.
//

import Foundation
import SwiftUI


struct HistoricalChartsData:Hashable,Codable{
    let o:[Double]
    let h:[Double]
    let l:[Double]
    let c:[Double]
    let v:[Int]
    let t:[Int]
}

class HistoricalDataModel:ObservableObject {
    @Published var openPriceData:[Double]=[]
    @Published var highPriceData:[Double]=[]
    @Published var lowPriceData:[Double]=[]
    @Published var currentPriceData:[Double]=[]
    @Published var volumeData:[Int]=[]
    @Published var timeData:[Int]=[]
    @Published var combinedData:[[Any]]=[]
    @Published var isFetchingData: Bool = true
    func fetch(stockName:String)  {

        guard let url=URL(string:"https://financehubbackend.wl.r.appspot.com/api/v1.0.0/histcharts/" + stockName + "/date/05-01-2020") else{
            return
        }

        let task=URLSession.shared.dataTask(with: url){[weak self]
            data,_,error in guard let data = data, error==nil else {
                return
            }


            do{
                let histData=try JSONDecoder().decode(HistoricalChartsData.self, from: data)
                self!.openPriceData=histData.o
                self!.highPriceData=histData.h
                self!.lowPriceData=histData.l
                self!.currentPriceData=histData.c
                self!.volumeData=histData.v
                self!.timeData=histData.t


                for index in 0 ..< self!.openPriceData.count{
                    self!.combinedData.append([ self!.openPriceData[index], self!.highPriceData[index], self!.lowPriceData[index], self!.currentPriceData[index], self!.volumeData[index], self!.timeData[index]])
                }
                self!.isFetchingData = false
                //print(self!.combinedData)

            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}

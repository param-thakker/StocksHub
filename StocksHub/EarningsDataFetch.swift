//
//  EarningsDataFetch.swift
//  StocksHub
//
//  Created by Param Thakker on 5/1/22.
//

import Foundation
import SwiftUI

struct EPSData:Codable{
        let actual:Double
        let estimate:Double
        let period:String
        let surprise:Double
}

class EPSModel:ObservableObject {
    @Published var results:[EPSData]=[]
    @Published var actualData:[Double]=[]
    @Published var estimateData:[Double]=[]
    @Published var periodData:[String]=[]
    @Published var surpriseData:[Double]=[]
    @Published var combinedXData:[String]=[]
    @Published var isFetchingData: Bool = true
    func fetch(stockName:String)  {
        print("fetch function called")
        guard let url=URL(string:"https://financehubbackend.wl.r.appspot.com/api/v1.0.0/companyearnings/"+stockName) else{
            return
        }
    
        let task=URLSession.shared.dataTask(with: url){
            data,_,error in guard let data = data, error==nil else {
                return
            }
             
            do{
                let results=try JSONDecoder().decode([EPSData].self, from: data)
                DispatchQueue.main.async {[self] in
                    self.results=results

                    
                    for index in 0 ..< self.results.count {
                        self.actualData.append(self.results[index].actual)
                        self.estimateData.append(self.results[index].estimate)
                        self.periodData.append(self.results[index].period)
                        self.surpriseData.append(self.results[index].surprise)
                        self.combinedXData.append("\(self.results[index].period)</br>Surprise:\(self.results[index].surprise)")
                    }
                    print(self.results)
                    self.isFetchingData = false
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}

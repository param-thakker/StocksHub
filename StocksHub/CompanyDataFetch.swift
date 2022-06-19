//
//  CompanyDataFetch.swift
//  StocksHub
//
//  Created by Param Thakker on 5/1/22.
//

import Foundation
import SwiftUI



struct Metadata: Codable{
    let name:String
    let logo:String
    let finnhubIndustry:String
    let ipo:String
    let weburl:String
}



class MetadataModel:ObservableObject {
    @Published var companyName: String = ""
    @Published var logolink: String = ""
    @Published var industry: String = ""
    @Published var ipoDate: String = ""
    @Published var url: String = ""
    @Published var isFetchingData: Bool = true
    func fetch(stockName:String)  {
        guard let url=URL(string:"https://financehubbackend.wl.r.appspot.com/api/v1.0.0/metadata/" + stockName) else{
            return
        }

        let task=URLSession.shared.dataTask(with: url){[weak self]
            data,_,error in guard let data = data, error==nil else {
                return
            }

            do{
                let metadata=try JSONDecoder().decode(Metadata.self, from: data)
                self?.companyName=metadata.name
                self?.logolink=metadata.logo
                self?.industry=metadata.finnhubIndustry
                self?.ipoDate=metadata.ipo
                self?.url=metadata.weburl
                self?.isFetchingData=false

            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}




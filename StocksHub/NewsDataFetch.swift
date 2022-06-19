//
//  NewsDataFetch.swift
//  StocksHub
//
//  Created by Param Thakker on 5/1/22.
//

import Foundation
import SwiftUI

struct News:Hashable,Codable{
    let headline:String
    let image:String
    let datetime:Double
    let source:String
    let summary:String
    let url:String
}

class NewsModel:ObservableObject {
    @Published var news:[News]=[]
    @Published var isFetchingData: Bool = true
    func fetch(stockName:String) {
       
        guard let url=URL(string:"https://financehubbackend.wl.r.appspot.com/api/v1.0.0/news/" + stockName) else{
            return
        }
    
        let task=URLSession.shared.dataTask(with: url){[weak self]
            data,_,error in guard let data = data, error==nil else {
                return
            }
             
            do{
                let news=try JSONDecoder().decode([News].self, from: data)
                DispatchQueue.main.async {
                    self?.news=news
                    self?.isFetchingData=false
                    print("%%%%%%%%%%%%%%%%%%%%%")
                    print(self?.news.endIndex)
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}



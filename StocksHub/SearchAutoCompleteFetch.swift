//
//  SearchAutoCompleteFetch.swift
//  StocksHub
//
//  Created by Param Thakker on 5/2/22.
//

import Foundation
import SwiftUI


struct Search: Hashable, Codable{
    let displaySymbol:String
    let description:String
}
class SearchModel:ObservableObject {
    @Published var results:[Search]=[]
    func fetch(ticker:String){
        guard let url=URL(string:"https://financehubbackend.wl.r.appspot.com/api/v1.0.0/searchutil/" + ticker) else{
            return
        }
    
        let task=URLSession.shared.dataTask(with: url){[weak self]
            data,_,error in guard let data = data, error==nil else {
                return
            }
             
            do{
                let results=try JSONDecoder().decode([Search].self, from: data)
                DispatchQueue.main.async {
                    self?.results=results
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}


//
//  PeersFetch.swift
//  StocksHub
//
//  Created by Param Thakker on 5/1/22.
//

import Foundation
import SwiftUI


class PeersModel:ObservableObject {
    @Published var peers:[String]=[]
    @Published var isFetchingData: Bool = true
    func fetch(stockName:String) {
       
        guard let url=URL(string:"https://financehubbackend.wl.r.appspot.com/api/v1.0.0/companypeers/" + stockName) else{
            return
        }
    
        let task=URLSession.shared.dataTask(with: url){[weak self]
            data,_,error in guard let data = data, error==nil else {
                return
            }
             
            do{
                let peers=try JSONDecoder().decode([String].self, from: data)
                DispatchQueue.main.async {
                    self?.peers=peers
                    self?.isFetchingData=false
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}

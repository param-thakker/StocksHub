//
//  SentimentsFetch.swift
//  StocksHub
//
//  Created by Param Thakker on 5/1/22.
//

import Foundation
import SwiftUI

struct mentions:Hashable,Codable{
    let mention:Int
    let positiveMention:Int
    let negativeMention: Int
}
struct Sentiments: Codable, Hashable{
    let reddit:[mentions]
    let twitter:[mentions]
}

class SentimentsModel:ObservableObject {
    @Published var redditMentions: [mentions]=[]
    @Published var twitterMentions: [mentions]=[]
    @Published var redditPositiveMentions:Int=0
    @Published var redditNegativeMentions:Int=0
    @Published var redditTotalMentions:Int=0
    @Published var twitterPositiveMentions:Int=0
    @Published var twitterNegativeMentions:Int=0
    @Published var twitterTotalMentions:Int=0
    @Published var isFetchingData: Bool = true
  
    func fetch(stockName:String)  {
        guard let url=URL(string:"https://financehubbackend.wl.r.appspot.com/api/v1.0.0/sentiments/" + stockName) else{
            return
        }

        let task=URLSession.shared.dataTask(with: url){[weak self]
            data,_,error in guard let data = data, error==nil else {
                return
            }

            do{
                let sentiments=try JSONDecoder().decode(Sentiments.self, from: data)
                self?.redditMentions=sentiments.reddit
                self?.twitterMentions=sentiments.twitter
           
                for index in 0 ..< self!.redditMentions.count {
                    self!.redditPositiveMentions+=self!.redditMentions[index].positiveMention ?? 0
                    self!.redditNegativeMentions+=self!.redditMentions[index].negativeMention ?? 0
                    self!.redditTotalMentions+=self!.redditMentions[index].mention ?? 0
                }
                for index in 0 ..< self!.twitterMentions.count {
                    self!.twitterPositiveMentions+=self!.twitterMentions[index].positiveMention ?? 0
                    self!.twitterNegativeMentions+=self!.twitterMentions[index].negativeMention ?? 0
                    self!.twitterTotalMentions+=self!.twitterMentions[index].mention ?? 0
                }
                
                self?.isFetchingData=false
        
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}

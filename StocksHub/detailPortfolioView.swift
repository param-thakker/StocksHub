//
//  detailPortfolioView.swift
//  StocksHub
//
//  Created by Param Thakker on 5/3/22.
//

import Foundation
import SwiftUI


struct portfolioSection:View{
    @State var existsInPortfolio:Bool=false
    @State var shares:Int=0
//    @Binding var shares:Int
    @State var avgCost:Double=0
    @State var ticker:String
    @State var currentPrice:Double
    @State var boolTemp: Bool
    @State private var portfolioStocks:[PortfolioComp]=refreshPortfolio()
    //@Binding var refreshDetailPage:Bool
    var body:some View{
        if (boolTemp){
            ProgressView().onAppear(){
                self.portfolioStocks=refreshPortfolio()
                print("#################################")
                print(self.portfolioStocks)
                for index in 0 ..< portfolioStocks.count {
                    if (portfolioStocks[index].stockTicker==ticker){
                        self.existsInPortfolio=true
                        self.shares=portfolioStocks[index].numShares
                        self.avgCost=portfolioStocks[index].avgPrice
                        print("HELLO THERE")

                    }
                }
               
                boolTemp = false
            }
        }
        else{
            VStack(alignment: .leading) {

                
                if (existsInPortfolio) {
                    
                
                        HStack{
                            VStack(alignment:.leading,spacing:5){
                                Text("Shares Owned:")
                                .font(.system(size: 14))
                                .bold()
                                Text("Avg. Cost/Share:")
                                    .font(.system(size: 14))
                                    .bold()
                                Text("Total Cost:")
                                .font(.system(size: 14))
                                .bold()
                                Text("Change:").font(.system(size: 14))
                                    .bold()
                                Text("Market Value:")
                                .font(.system(size: 14))
                                .bold()
                            }
                            Spacer()
                            VStack(alignment:.leading,spacing:5){
                                Text(String(shares)).font(.system(size: 14))
                               Text("$\(avgCost,specifier: "%.2f")").font(.system(size: 14))

                               Text("$\(avgCost*Double(shares),specifier: "%.2f")").font(.system(size:14))
                                if ((currentPrice-avgCost)*Double(shares)>0){
                                    Text("$\((currentPrice-avgCost)*Double(shares),specifier: "%.2f")")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.green)
                                    Text("$\(currentPrice*Double(shares),specifier: "%.2f")")
                                        .font(.system(size: 14)).foregroundColor(Color.green)
                                }
                                else if ((currentPrice-avgCost)*Double(shares)<0){
                                    Text("$\((currentPrice-avgCost)*Double(shares),specifier: "%.2f")")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.red)
                                    Text("$\(currentPrice*Double(shares),specifier: "%.2f")")
                                        .font(.system(size: 14)).foregroundColor(Color.red)
                                }
                                else{
                                    Text("$\((currentPrice-avgCost)*Double(shares),specifier: "%.2f")")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.gray)
                                    Text("$\(currentPrice*Double(shares),specifier: "%.2f")")
                                        .font(.system(size: 14)).foregroundColor(Color.gray)
                                }
                               
                            }
                            Spacer()
                         
                        }
                    //Text("\n\n")
                }
                else{
                 
                        Text("You have 0 shares of \(ticker).")
                            .font(.system(size: 14))
                            .bold()
                        Text("Start trading!")
                            .font(.system(size: 14))
                            .bold()
                    
                        //Text("\n\n")
                    
                }

            }.onAppear{
                self.portfolioStocks=refreshPortfolio()
                for index in 0 ..< portfolioStocks.count {
                    if (portfolioStocks[index].stockTicker==ticker){
                        existsInPortfolio=true
                        shares=portfolioStocks[index].numShares
                        avgCost=portfolioStocks[index].avgPrice

                    }
                }
       
                }
        }
        
        
        
        
//        VStack(alignment: .leading) {
////            let portfolioStocks=refreshPortfolio()
////            var existsInPortfolio=false
////            var shares=0.0
////            var avgCost=0.0
////            ForEach(0..<portfolioStocks.endIndex){
////                i in
////                if (portfolioStocks[i].stockTicker == ticker){
////                    existsInPortfolio=true
////                    shares=Double(portfolioStocks[i].numShares)
////                    avgCost=portfolioStocks[i].avgPrice
////
////                }
////            }
//////            for index in 0 ..< portfolioStocks.count {
//////                if (portfolioStocks[index].stockTicker==ticker){
//////                    existsInPortfolio=true
//////                    shares=portfolioStocks[index].numShares
//////                    avgCost=portfolioStocks[index].avgPrice
//////
//////                }
//////            }
//
//            if (existsInPortfolio) {
//
//                //self.portfolioStocks=refreshPortfolio()
//                    HStack{
//                        VStack(alignment:.leading,spacing:5){
//                            Text("Shares Owned:")
//                            .font(.system(size: 14))
//                            .bold()
//                            Text("Avg. Cost/Share:")
//                                .font(.system(size: 14))
//                                .bold()
//                            Text("Total Cost:")
//                            .font(.system(size: 14))
//                            .bold()
//                            Text("Change:").font(.system(size: 14))
//                                .bold()
//                            Text("Market Value:")
//                            .font(.system(size: 14))
//                            .bold()
//                        }
//                        Spacer()
//                        VStack(alignment:.leading,spacing:5){
//                            Text(String(shares)).font(.system(size: 14))
//                           Text("$\(avgCost,specifier: "%.2f")").font(.system(size: 14))
//
//                           Text("$\(avgCost*Double(shares),specifier: "%.2f")").font(.system(size:14))
//                            if ((currentPrice-avgCost)*Double(shares)>0){
//                                Text("$\((currentPrice-avgCost)*Double(shares),specifier: "%.2f")")
//                                .font(.system(size: 14))
//                                .foregroundColor(Color.green)
//                            }
//                            else if ((currentPrice-avgCost)*Double(shares)<0){
//                                Text("$\((currentPrice-avgCost)*Double(shares),specifier: "%.2f")")
//                                .font(.system(size: 14))
//                                .foregroundColor(Color.red)
//                            }
//                            else{
//                                Text("$\((currentPrice-avgCost)*Double(shares),specifier: "%.2f")")
//                                .font(.system(size: 14))
//                                .foregroundColor(Color.gray)
//                            }
//                            Text("$\(currentPrice*Double(shares),specifier: "%.2f")")
//                            .font(.system(size: 14))
//                        }
//                        Spacer()
//
//                    }
//            }
//            else{
//
//                    Text("You have 0 shares of \(ticker).")
//                        .font(.system(size: 14))
//                        .bold()
//                    Text("Start trading!")
//                        .font(.system(size: 14))
//                        .bold()
//
//            }
//
//        }.onAppear{
//            self.portfolioStocks=refreshPortfolio()
//            for index in 0 ..< portfolioStocks.count {
//                if (portfolioStocks[index].stockTicker==ticker){
//                    existsInPortfolio=true
//                    shares=portfolioStocks[index].numShares
//                    avgCost=portfolioStocks[index].avgPrice
//
//                }
//            }
//            //refreshDetailPage=false      //
//
//            }
//
        
            
            
            
            
            
            
            
        
                    
//            VStack(alignment: .leading){
//                if (existsInPortfolio){
//                    HStack{
//
//                        VStack(alignment:.leading,spacing:5){
//                            Text("Shares Owned:")
//                            .font(.system(size: 14))
//                            .bold()
//                            Text("Avg. Cost/Share:")
//                                .font(.system(size: 14))
//                                .bold()
//                            Text("Total Cost:")
//                            .font(.system(size: 14))
//                            .bold()
//                            Text("Change:").font(.system(size: 14))
//                                .bold()
//                            Text("Market Value:")
//                            .font(.system(size: 14))
//                            .bold()
//                        }
//                        Spacer()
//                        VStack(alignment:.leading,spacing:5){
//                            Text(String(shares)).font(.system(size: 14))
//                           Text("$\(avgCost,specifier: "%.2f")").font(.system(size: 14))
//
//                           Text("$\(avgCost*Double(shares),specifier: "%.2f")").font(.system(size:14))
//                            if ((lpModel.currentPrice-avgCost)*Double(shares)>0){
//                                Text("$\((lpModel.currentPrice-avgCost)*Double(shares),specifier: "%.2f")")
//                                .font(.system(size: 14))
//                                .foregroundColor(Color.green)
//                            }
//                            else if ((lpModel.currentPrice-avgCost)*Double(shares)<0){
//                                Text("$\((lpModel.currentPrice-avgCost)*Double(shares),specifier: "%.2f")")
//                                .font(.system(size: 14))
//                                .foregroundColor(Color.red)
//                            }
//                            else{
//                                Text("$\((lpModel.currentPrice-avgCost)*Double(shares),specifier: "%.2f")")
//                                .font(.system(size: 14))
//                                .foregroundColor(Color.gray)
//                            }
//                            Text("$\(lpModel.currentPrice*Double(shares),specifier: "%.2f")")
//                            .font(.system(size: 14))
//                        }
//                        Spacer()
//                    }
//
//                }
//                else{
//                    Text("You have 0 shares of \(ticker).")
//                        .font(.system(size: 14))
//                        .bold()
//                    Text("Start trading!")
//                        .font(.system(size: 14))
//                        .bold()
//                }
//            }.onAppear{
//                self.portfolioStocks=refreshPortfolio()
//            }
        
        
        
//        
//        
//            Spacer()
//            Button(action: {
//                showingSheet.toggle()
//            }, label: {
//                Text("Trade")
//                    .frame(width: 175, height: 50)
//                    .foregroundColor(Color.white)
//                    .background(Color.green)
//                    .cornerRadius(70)
//            })
//            .buttonStyle(BorderlessButtonStyle())
//            .sheet(isPresented: $showingSheet) {
//                TradeSheet(availableCash: UserDefaults.standard.double(forKey: "totalCash") ?? 25000.00, ticker: ticker,companyName:metadataModel.companyName,currentPrice:lpModel.currentPrice,toastMessage:"",availableShares: 0,portfolioStocks: portfolioStocks)
//            }
//            Spacer()
//
//        }.toast(isShowing: $addFav, text: Text("Adding \(ticker) to Favorites"))
//            .toast(isShowing: $removeFav, text: Text("Removed \(ticker) from Favorites"))
    }
}

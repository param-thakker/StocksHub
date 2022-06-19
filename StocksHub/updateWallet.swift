//
//  updateWallet.swift
//  StocksHub
//
//  Created by Param Thakker on 5/3/22.
//

import Foundation
import SwiftUI


struct walletView:View{
    @State private var totalCash:Double=refreshWalletBalance()
    @State private var portfolioStocks:[PortfolioComp]=refreshPortfolio()
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    @StateObject var lpModel: LatestPriceModel = LatestPriceModel()
    @AppStorage("NetWorth") var netWorth:Double=Double(25000.00)
    var body: some View{
        HStack {
            VStack(alignment: .leading){
                Text("Net Worth").font(.system(size:23))

                Text("$\(netWorth, specifier: "%.2f")").font(.system(size:22)).bold()
            }

            Spacer()
            VStack(alignment: .leading){
            Text("Cash Balance").font(.system(size:23))

                Text("$\(totalCash, specifier: "%.2f")").font(.system(size:22)).bold()
            }

        }.onAppear{
            self.totalCash=refreshWalletBalance()
            self.portfolioStocks=refreshPortfolio()
        }
        .onReceive(timer){
            time in
            lpModel.isFetchingData=true
        }
    }
//
//    func calculateMarketValueOfStocks(){
//        var sum:Double=0
//        ForEach(portfolioStocks, id: \.self) {  stock in
//            
//        }
//    }
  

}

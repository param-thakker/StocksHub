//
//  TradeSheet.swift
//  StocksHub
//
//  Created by Param Thakker on 4/29/22.
//

import Foundation
import SwiftUI
import SimpleToast
import ToastSwiftUI
import SheetKit

struct TradeSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var shares: String = ""
    @State var availableCash: Double=refreshWalletBalance()
    @State var ticker: String
    @State var companyName: String
    @State var currentPrice: Double
    @State private var notEnoughMoney = false
    @State private var isNegativeShares = false
    @State private var isShowingToast = false
    @State private var showToast: Bool = false
    @State private var showingSheet=false
    @State private var showingSellSheet=false
    @State var toastMessage:String
    @State var availableShares: Int=0
    //@State var portfolioStocks:[PortfolioComp]
    @State var portfolioStocks:[PortfolioComp]=refreshPortfolio()
    @Binding var refreshDetailPage:Bool
    let toastOptions=SimpleToastOptions(alignment:.bottom,hideAfter: 3)
    
    @State var change: Double
    @State var percentChange: Double
    


    var body: some View {
        
        NavigationView{
        VStack {
         
            Text("\n\n")
            Text("Trade \(companyName) shares").font(.system(size: 25)).foregroundColor(Color.black).bold()
            Text("\n\n\n\n\n\n")
            
            HStack{
            TextField("0", text: $shares).padding(.leading, 25.0).keyboardType(.numberPad).font(.system(size: 70))
             
                if ((Double(shares) ?? 0)>1){
            Text("Shares").font(.system(size: 45))
            }
                else{
                    Text("Share").font(.system(size: 45))
                }
                Spacer()
               
            }

            Text("\t\t\t\t\tx $\(currentPrice,specifier: "%.2f")/share = $\((Double(shares) ?? 0)*currentPrice,specifier: "%.2f")")
              .font(.system(size: 18))

           
            Spacer()
           
            Text("$\(availableCash, specifier: "%.2f") available to buy \(ticker)").foregroundColor(Color.gray).padding(.bottom, 7.0)

            HStack{
            Button(action: {
                if ((Double(shares)) ?? 0==0){
                    //isShowingToast.toggle()
                    self.showToast.toggle()
                    toastMessage="Cannot buy non-positive shares"
                    
                }
                else if ((Double(shares) ?? 0)*currentPrice<=availableCash){
                    var updatedShares=availableShares+(Int(shares) ?? 0)
                    updatePortfolioOnBuy(numberofShares: updatedShares)
                    
                    print("Total shares are now " + String(updatedShares))
                    showingSheet.toggle()
                    let totalCash = UserDefaults.standard.double(forKey: "totalCash") ?? 25000.00
                    UserDefaults.standard.set(totalCash-((Double(shares) ?? 0)*currentPrice), forKey: "totalCash")
                    refreshDetailPage=true
                   
            }
                else{
                    //isShowingToast.toggle()
                    self.showToast.toggle()
                    toastMessage="Not enough money to buy"
                }
               
                        }) {
                        Text("Buy")
                            .frame(width: 175, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.green)
                            .cornerRadius(90)
                        }
                        .padding(.bottom, 27.5)
                
                
                
                Button(action: {
                    if ((Double(shares)) ?? 0==0){
                        self.showToast.toggle()
                        toastMessage="Cannot sell non-positive shares"
                        
                    }
                    else if (Int(shares) ?? 0<=availableShares){
                        var remainingShares=availableShares-(Int(shares) ?? 0)
                        updatePortfolioOnSell(numberofShares:remainingShares)
                        showingSellSheet.toggle()
                        let totalCash = UserDefaults.standard.double(forKey: "totalCash") ?? 25000.00
                        UserDefaults.standard.set(totalCash+((Double(shares) ?? 0)*currentPrice), forKey: "totalCash")
                        refreshDetailPage=true
                    }
             
                    else{
                        self.showToast.toggle()
                        toastMessage="Not enough shares to sell"
                    }
                } ){
                        Text("\t")
                        Text("Sell")
                            .frame(width: 175, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.green)
                            .cornerRadius(90)
                }
                .padding(.bottom, 27.5)
            
            }
            
        }.navigationBarItems(trailing: Button(action: {
            SheetKit().dismissAllSheets(animated:false)
        }, label: {
            Image(systemName: "xmark").foregroundColor(Color.black)
        }))
            
        .simpleToast(isShowing: self.$showToast, options: toastOptions, content: {
            Text(self.toastMessage).padding().clipShape(Capsule()).foregroundColor(Color.white).background(Color.gray).cornerRadius(20).frame(width: 350)
        })

        //.toast(isShowing: $showToast, text: Text(toastMessage))
       
            .sheet(isPresented: $showingSheet) {
                CongratsSheet(shares: Int(shares) ?? 0, ticker: ticker, refreshDetailPage: $refreshDetailPage)
            }
            .sheet(isPresented: $showingSellSheet) {
                CongratsSellSheet(shares: Int(shares) ?? 0, ticker: ticker, refreshDetailPage:$refreshDetailPage)
            }
           .background(Color.white)
           .onAppear{
               self.portfolioStocks=refreshPortfolio()
               for index in 0 ..< portfolioStocks.count {
                   if (portfolioStocks[index].stockTicker==ticker){
                       availableShares=portfolioStocks[index].numShares
  
                   }
               }
             
           }
        }
        
        
    }
    
    
    func updatePortfolioOnBuy(numberofShares:Int){
        var foundInPortfolio=false
        let portfolioComp=PortfolioComp(ticker:ticker,shares:numberofShares,avg: currentPrice, latestprice: currentPrice,stockChange:change,stockPercentChange:percentChange)
        if (UserDefaults.standard.object(forKey: "portfolioList")==nil){
            let portfolioList=[portfolioComp]
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(portfolioList)
                    UserDefaults.standard.set(data, forKey: "portfolioList")

                } catch { }
        }
        
        else{
        for index in 0 ..< portfolioStocks.count {
            if (portfolioStocks[index].stockTicker==ticker){
                var comp=portfolioStocks[index]
                var prevTotal=comp.avgPrice*Double(comp.numShares)
                var newTotal=(Double(shares) ?? 0)*currentPrice
                comp.avgPrice=(prevTotal + newTotal)/Double(numberofShares)
                comp.numShares=numberofShares
                portfolioStocks[index]=comp
                foundInPortfolio=true
     
         }
        }
            if (!foundInPortfolio){
                portfolioStocks.append(portfolioComp)
            }
            
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(portfolioStocks)
                UserDefaults.standard.set(data, forKey: "portfolioList")

            } catch { }
        }

    }
    func updatePortfolioOnSell(numberofShares:Int){
        if (UserDefaults.standard.object(forKey: "portfolioList")==nil){
           return
        }
            if let data = UserDefaults.standard.data(forKey: "portfolioList") {
            do {
                let decoder = JSONDecoder()
                var portfolioList = try decoder.decode([PortfolioComp].self, from: data)
                for index in 0 ..< portfolioList.count {
                    if (portfolioList[index].stockTicker==ticker){
                        if (numberofShares==0){
                        portfolioList.remove(at: index)
                            break
                        }
                        else{
                            var comp=portfolioList[index]
                            comp.numShares=numberofShares
                            portfolioList[index]=comp
                            break
                        }
                 }
                }
                
                if (portfolioList.isEmpty || portfolioList.count==0){
                    UserDefaults.standard.removeObject(forKey: "portfolioList")
                }
                
                else{
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(portfolioList)
                    
                    UserDefaults.standard.set(data, forKey: "portfolioList")

                } catch {}
                }

            } catch {}
            }
        
    }
}



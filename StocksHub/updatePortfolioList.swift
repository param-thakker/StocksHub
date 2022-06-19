//
//  updatePortfolioList.swift
//  StocksHub
//
//  Created by Param Thakker on 5/3/22.
//

import Foundation
import SwiftUI




struct portfolioLatestStockPrice:View{
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    var parameter:PortfolioComp
   
    @StateObject var lpModel: LatestPriceModel = LatestPriceModel()
    @State var portfolioStocks:[PortfolioComp]
    var list:[Double]=[]
   
    //@State var index:Int

    var body:some View{
        var marketValueSum:Double=0.0
        //else{
        HStack{
            VStack(alignment: .leading){
                Text(parameter.stockTicker).bold().font(.system(size: 22))
                if (parameter.numShares>1){
                Text(String(parameter.numShares) + " shares").font(.system(size: 15)).font(.caption).foregroundColor(Color.gray)
                }
                else{
                    Text(String(parameter.numShares) + " share").font(.system(size: 15)).font(.caption).foregroundColor(Color.gray)
                }

            }
            Spacer()
            if (lpModel.isFetchingData==true){
                ProgressView().onAppear{
                    lpModel.fetch(stockName: parameter.stockTicker)
 
                }
            }
            else{
                 //var stockMarketValueSum=lpModel.currentPrice*Double(parameter.numShares)
            VStack(alignment: .trailing){
                Text("$\(lpModel.currentPrice * Double(parameter.numShares), specifier: "%.2f")").bold()
                
                //marketValueSum=marketValueSum+lpModel.currentPrice * Double(parameter.numShares)
                if (((lpModel.currentPrice-parameter.avgPrice)*Double(parameter.numShares))<0){
                    HStack{
                        Image(systemName: "arrow.down.forward").foregroundColor(Color.red)
                    Text("$\(((lpModel.currentPrice-parameter.avgPrice)*Double(parameter.numShares)), specifier: "%.2f") (\(      ((lpModel.currentPrice-parameter.avgPrice)*Double(parameter.numShares))*100/(parameter.avgPrice*Double(parameter.numShares)), specifier: "%.2f")%)").foregroundColor(Color.red)
                    }
                }
                else  if (((lpModel.currentPrice-parameter.avgPrice)*Double(parameter.numShares))>0){
                    HStack{
                        Image(systemName: "arrow.up.forward").foregroundColor(Color.green)
                    Text("$\(((lpModel.currentPrice-parameter.avgPrice)*Double(parameter.numShares)), specifier: "%.2f") (\(      ((lpModel.currentPrice-parameter.avgPrice)*Double(parameter.numShares))*100/(parameter.avgPrice*Double(parameter.numShares)), specifier: "%.2f")%)").foregroundColor(Color.green)
                    }
                }
                else{
                    HStack{
                        Image(systemName: "minus").foregroundColor(Color.gray)
                    Text("$\(((lpModel.currentPrice-parameter.avgPrice)*Double(parameter.numShares)), specifier: "%.2f") (\(      ((lpModel.currentPrice-parameter.avgPrice)*Double(parameter.numShares))*100/(parameter.avgPrice*Double(parameter.numShares)), specifier: "%.2f")%)").foregroundColor(Color.gray)
                    }
                }

            }
        }

        }.onReceive(timer){
            time in
            lpModel.isFetchingData=true
           
            print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
            print("on receive called for \(parameter.stockTicker)")
            let cashBalance = UserDefaults.standard.double(forKey: "totalCash") ?? 25000.00
            @AppStorage("NetWorth") var netWorth:Double=Double(25000.00)
            //var marketValueSum:Double=0
           // marketValueSum=marketValueSum+lpModel.currentPrice*Double(parameter.numShares)
         
//            for index in 0 ..< portfolioStocks.count {
//                marketValueSum=marketValueSum+lpModel.currentPrice*Double(parameter.numShares)
//            }
            //netWorth=cashBalance+Double(marketValueSum)
        }
            //}
    }

}

struct portfolioView:View{
    @State private var favoriteStocks:[FavoriteComp]=refreshFavorites()
    @State private var portfolioStocks:[PortfolioComp]=refreshPortfolio()
    @StateObject var lpModel=LatestPriceModel()
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()

    var body: some View{
        ForEach(portfolioStocks, id: \.self) {                  stock in
            NavigationLink(destination: Details(ticker:stock.stockTicker,favoriteStocks:favoriteStocks,portfolioStocks:portfolioStocks,shares: 0,avgCost:0,strongBuyData:[],buyData: [],holdData: [],sellData:[],strongSellData:[], toOpenIndex: 2,newsSource:" ",newsSummary:" ",newsHeadline:" ",newsURL:" ",newsDate:0.0,toastMessage: "")){

                portfolioLatestStockPrice(parameter: stock, portfolioStocks:portfolioStocks)

//            if (lpModel.isFetchingData==true){
//                ProgressView().onAppear{
//                    lpModel.fetch(stockName: stock.stockTicker)
//                }
//            }
//            else{
//            HStack{
//                VStack(alignment: .leading){
//                    Text(stock.stockTicker).bold().font(.system(size: 22))
//                    if (stock.numShares>1){
//                    Text(String(stock.numShares) + " shares").font(.system(size: 15)).font(.caption).foregroundColor(Color.gray)
//                    }
//                    else{
//                        Text(String(stock.numShares) + " share").font(.system(size: 15)).font(.caption).foregroundColor(Color.gray)
//                    }
//
//                }
//                Spacer()
//                VStack(alignment: .trailing){
//                    Text("$\(lpModel.currentPrice * Double(stock.numShares), specifier: "%.2f")").bold()
//                    if (((lpModel.currentPrice-stock.avgPrice)*Double(stock.numShares))<0){
//                        HStack{
//                            Image(systemName: "arrow.down.forward").foregroundColor(Color.red)
//                        Text("$\(((lpModel.currentPrice-stock.avgPrice)*Double(stock.numShares)), specifier: "%.2f") (\(      ((lpModel.currentPrice-stock.avgPrice)*Double(stock.numShares))*100/(stock.avgPrice*Double(stock.numShares)), specifier: "%.2f")%)").foregroundColor(Color.red)
//                        }
//                    }
//                    else  if (((lpModel.currentPrice-stock.avgPrice)*Double(stock.numShares))>0){
//                        HStack{
//                            Image(systemName: "arrow.down.forward").foregroundColor(Color.green)
//                        Text("$\(((lpModel.currentPrice-stock.avgPrice)*Double(stock.numShares)), specifier: "%.2f") (\(      ((lpModel.currentPrice-stock.avgPrice)*Double(stock.numShares))*100/(stock.avgPrice*Double(stock.numShares)), specifier: "%.2f")%)").foregroundColor(Color.green)
//                        }
//                    }
//                    else{
//                        HStack{
//                            Image(systemName: "minus").foregroundColor(Color.gray)
//                        Text("$\(((lpModel.currentPrice-stock.avgPrice)*Double(stock.numShares)), specifier: "%.2f") (\(      ((lpModel.currentPrice-stock.avgPrice)*Double(stock.numShares))*100/(stock.avgPrice*Double(stock.numShares)), specifier: "%.2f")%)").foregroundColor(Color.gray)
//                        }
//                    }
//
//                }
//
//            }.onReceive(timer){
//                time in
//                lpModel.isFetchingData=true
//            }
//                }
        }
                       }


    .onMove(perform: movePortfolio)
    .onAppear{
        self.portfolioStocks=refreshPortfolio()
    }


        .padding(/*@START_MENU_TOKEN@*/.horizontal, 12.0/*@END_MENU_TOKEN@*/)
    }
    func movePortfolio(from source:IndexSet,to destination:Int){
        let reversedSource=source.sorted()
        for index in reversedSource.reversed(){
            portfolioStocks.insert(portfolioStocks.remove(at:index),at:destination)
        }

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(portfolioStocks)
            UserDefaults.standard.set(data, forKey: "portfolioList")

        } catch {

        }
    }

}








//struct portfolioView:View{
//    @State private var favoriteStocks:[FavoriteComp]=refreshFavorites()
//    @State private var portfolioStocks:[PortfolioComp]=refreshPortfolio()
//    @StateObject var lpModel=LatestPriceModel()
//
//    var body: some View{
//        ForEach(portfolioStocks, id: \.self) {                  stock in
//            NavigationLink(destination: Details(ticker:stock.stockTicker,favoriteStocks:favoriteStocks,portfolioStocks:portfolioStocks,shares: 0,avgCost:0,strongBuyData:[],buyData: [],holdData: [],sellData:[],strongSellData:[], toOpenIndex: 2,newsSource:" ",newsSummary:" ",newsHeadline:" ",newsURL:" ",newsDate:0.0,toastMessage: "")){
//            HStack{
//                VStack(alignment: .leading){
//                    Text(stock.stockTicker).bold().font(.system(size: 22))
//                    if (stock.numShares>1){
//                    Text(String(stock.numShares) + " shares").font(.system(size: 15)).font(.caption).foregroundColor(Color.gray)
//                    }
//                    else{
//                        Text(String(stock.numShares) + " share").font(.system(size: 15)).font(.caption).foregroundColor(Color.gray)
//                    }
//
//                }
//                Spacer()
//                VStack(alignment: .trailing){
//                    Text("$\(stock.latestStockPrice * Double(stock.numShares), specifier: "%.2f")").bold()
//                    if (stock.change<0){
//                    HStack{
//                        Image(systemName: "arrow.down.forward").foregroundColor(Color.red)
//                        Text("$\(stock.change, specifier: "%.2f") (\(stock.percentChange, specifier: "%.2f")%)").foregroundColor(Color.red)
//                     }
//                    }
//                    else if (stock.change>0){
//                        HStack{
//                        Image(systemName: "arrow.up.forward").foregroundColor(Color.green)
//                        Text("$\(stock.change, specifier: "%.2f") (\(stock.percentChange, specifier: "%.2f")%)").foregroundColor(Color.green)
//                        }
//                    }
//                    else{
//                        HStack{
//                        Image(systemName: "minus").foregroundColor(Color.gray)
//                        Text("$\(stock.change, specifier: "%.2f") (\(stock.percentChange, specifier: "%.2f")%)").foregroundColor(Color.gray)
//                        }
//                    }
//
//
//
//
//
////                    if (((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares))<0){
////                        HStack{
////                            Image(systemName: "arrow.down.forward").foregroundColor(Color.red)
////                        Text("$\(((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares)), specifier: "%.2f") (\(      ((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares))*100/(stock.avgPrice*Double(stock.numShares)), specifier: "%.2f")%)").foregroundColor(Color.red)
////                        }
////                    }
////                    else if (((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares))>0){
////                        HStack{
////                            Image(systemName: "arrow.up.forward").foregroundColor(Color.green)
////                        Text("$\(((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares)), specifier: "%.2f") (\(      ((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares))*100/(stock.avgPrice*Double(stock.numShares)), specifier: "%.2f")%)").foregroundColor(Color.green)
////                        }
////                    }
////                    else{
////                        HStack{
////                            Image(systemName: "minus").foregroundColor(Color.gray)
////                        Text("$\(((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares)), specifier: "%.2f") (\(      ((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares))*100/(stock.avgPrice*Double(stock.numShares)), specifier: "%.2f")%)").foregroundColor(Color.gray)
////                        }
////                    }
//
//
//
//                }
//
//            }
//        }
//                       }
//
//
//    .onMove(perform: movePortfolio)
//    .onAppear{
//        self.portfolioStocks=refreshPortfolio()
//    }
//
//
//        .padding(/*@START_MENU_TOKEN@*/.horizontal, 12.0/*@END_MENU_TOKEN@*/)
//    }
//    func movePortfolio(from source:IndexSet,to destination:Int){
//        let reversedSource=source.sorted()
//        for index in reversedSource.reversed(){
//            portfolioStocks.insert(portfolioStocks.remove(at:index),at:destination)
//        }
//
//        do {
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(portfolioStocks)
//            UserDefaults.standard.set(data, forKey: "portfolioList")
//
//        } catch {
//
//        }
//    }
//
//}

//
//  updateFavoriteList.swift
//  StocksHub
//
//  Created by Param Thakker on 5/2/22.
//

import Foundation
import SwiftUI

struct favLatestStockPrice: View {
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    var comp: FavoriteComp
    @StateObject var lpModel: LatestPriceModel = LatestPriceModel()
    
    
    var body: some View {
        
      
        //else{
            HStack {
                VStack(alignment: .leading) {
                    Text(comp.stockTicker).bold().font(.system(size: 22))
                    Text(comp.stockName).font(.system(size: 17)).foregroundColor(Color.gray)

                }
           

                Spacer()
                if lpModel.isFetchingData {
                    ProgressView()
                        .onAppear{
                            lpModel.fetch(stockName: comp.stockTicker)
                        }
                }
                else{
           
                VStack(alignment: .trailing) {
                    //Text("$\(stock.stockPrice, specifier: "%.2f")").bold()
                    Text("$\(lpModel.currentPrice, specifier: "%.2f")").bold()
                    if (lpModel.change<0){
                        HStack{
                            Image(systemName: "arrow.down.forward").foregroundColor(Color.red)
                        Text("$\(lpModel.change, specifier: "%.2f") (\(lpModel.changePercent, specifier: "%.2f")%)").foregroundColor(Color.red)
                        }
                    }
                    else if (lpModel.change>0){
                        HStack{
                            Image(systemName: "arrow.up.forward").foregroundColor(Color.green)
                        Text("$\(lpModel.change, specifier: "%.2f") (\(lpModel.changePercent, specifier: "%.2f")%)").foregroundColor(Color.green)
                        }
                    }
                    else{
                        HStack{
                            Image(systemName: "minus").foregroundColor(Color.gray)
                        Text("$\(lpModel.change, specifier: "%.2f") (\(lpModel.changePercent, specifier: "%.2f")%)").foregroundColor(Color.gray)
                        }
                    }
                }
            }
    //                    .onAppear{
    //                        lpModel.fetch(stockName: stock.stockTicker)
    //                    }


            }
            .onReceive(timer){
                time in
                lpModel.isFetchingData = true
            }
        //}
        
        
    }
    
    
}
struct favView:View{

    @State private var favoriteStocks:[FavoriteComp]=refreshFavorites()
    @State private var portfolioStocks:[PortfolioComp]=refreshPortfolio()
    @StateObject var lpModel=LatestPriceModel()
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()

    var body: some View{

        ForEach(favoriteStocks, id: \.self) {  stock in

            NavigationLink(destination: Details(ticker:stock.stockTicker,favoriteStocks:favoriteStocks,portfolioStocks:portfolioStocks,shares: 0,avgCost:0,strongBuyData:[],buyData: [],holdData: [],sellData:[],strongSellData:[], toOpenIndex: 2,newsSource:" ",newsSummary:" ",newsHeadline:" ",newsURL:" ",newsDate:0.0,toastMessage: "")){

                favLatestStockPrice(comp: stock)
//                if (lpModel.isFetchingData==true){
//                    ProgressView().onAppear{
//                        lpModel.fetch(stockName: stock.stockTicker)
//                        print("#############################")
//                        print("calling fetch from update Favorite List for \(stock.stockTicker)")
//                    }
//                }
//                else{
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text(stock.stockTicker).bold().font(.system(size: 22))
//                        Text(stock.stockName).font(.system(size: 17)).foregroundColor(Color.gray)
//
//                    }
//
//                    Spacer()
//                    VStack(alignment: .trailing) {
//                        //Text("$\(stock.stockPrice, specifier: "%.2f")").bold()
//                        Text("$\(lpModel.currentPrice, specifier: "%.2f")").bold()
//                        if (lpModel.change<0){
//                            HStack{
//                                Image(systemName: "arrow.down.forward").foregroundColor(Color.red)
//                            Text("$\(lpModel.change, specifier: "%.2f") (\(lpModel.changePercent, specifier: "%.2f")%)").foregroundColor(Color.red)
//                            }
//                        }
//                        else if (lpModel.change>0){
//                            HStack{
//                                Image(systemName: "arrow.up.forward").foregroundColor(Color.green)
//                            Text("$\(lpModel.change, specifier: "%.2f") (\(lpModel.changePercent, specifier: "%.2f")%)").foregroundColor(Color.green)
//                            }
//                        }
//                        else{
//                            HStack{
//                                Image(systemName: "minus").foregroundColor(Color.gray)
//                            Text("$\(lpModel.change, specifier: "%.2f") (\(lpModel.changePercent, specifier: "%.2f")%)").foregroundColor(Color.gray)
//                            }
//                        }
//                    }
////                    .onAppear{
////                        lpModel.fetch(stockName: stock.stockTicker)
////                    }
//
//
//                }.onReceive(timer){
//                    time in
//                    lpModel.isFetchingData=true
//                }
//                }
            }
        }
        .onDelete(perform: deleteItem)
        .onMove(perform: moveFavorite)
        .onAppear{
            self.favoriteStocks=refreshFavorites()
        }

    }

    func deleteItem(at offsets: IndexSet){
        if let first=offsets.first{
            favoriteStocks.remove(at:first)
        }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favoriteStocks)
            UserDefaults.standard.set(data, forKey: "favoritesList")

        } catch {

        }


    }
    func moveFavorite(from source:IndexSet,to destination:Int){
        let reversedSource=source.sorted()
        for index in reversedSource.reversed(){
            favoriteStocks.insert(favoriteStocks.remove(at:index),at:destination)
        }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favoriteStocks)
            UserDefaults.standard.set(data, forKey: "favoritesList")

        } catch {

        }
    }
}








//struct favView:View{
//
//    @State private var favoriteStocks:[FavoriteComp]=refreshFavorites()
//    @State private var portfolioStocks:[PortfolioComp]=refreshPortfolio()
//    @StateObject var lpModel=LatestPriceModel()
//
//    var body: some View{
//
//        ForEach(favoriteStocks, id: \.self) {  stock in
//
//            NavigationLink(destination: Details(ticker:stock.stockTicker,favoriteStocks:favoriteStocks,portfolioStocks:portfolioStocks,shares: 0,avgCost:0,strongBuyData:[],buyData: [],holdData: [],sellData:[],strongSellData:[], toOpenIndex: 2,newsSource:" ",newsSummary:" ",newsHeadline:" ",newsURL:" ",newsDate:0.0,toastMessage: "")){
//
//
//
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text(stock.stockTicker).bold().font(.system(size: 22))
//                        Text(stock.stockName).font(.system(size: 17)).foregroundColor(Color.gray)
//
//                    }
//
//                    Spacer()
//                    VStack(alignment: .trailing){
//                        Text("$\(stock.stockPrice, specifier: "%.2f")").bold()
//                        if (stock.change<0){
//                            HStack{
//                                Image(systemName: "arrow.down.forward").foregroundColor(Color.red)
//                            Text("$\(stock.change, specifier: "%.2f") (\(stock.percentChange, specifier: "%.2f")%)").foregroundColor(Color.red)
//                            }
//                        }
//                        else if (stock.change>0){
//                            HStack{
//                                Image(systemName: "arrow.up.forward").foregroundColor(Color.green)
//                            Text("$\(stock.change, specifier: "%.2f") (\(stock.percentChange, specifier: "%.2f")%)").foregroundColor(Color.green)
//                            }
//                        }
//                        else{
//                            HStack{
//                                Image(systemName: "minus").foregroundColor(Color.gray)
//                            Text("$\(stock.change, specifier: "%.2f") (\(stock.percentChange, specifier: "%.2f")%)").foregroundColor(Color.gray)
//                            }
//                        }
//                    }
//
//
//                }
//            }
//        }
//        .onDelete(perform: deleteItem)
//        .onMove(perform: moveFavorite)
//        .onAppear{
//            self.favoriteStocks=refreshFavorites()
//        }
//
//    }
//
//    func deleteItem(at offsets: IndexSet){
//        if let first=offsets.first{
//            favoriteStocks.remove(at:first)
//        }
//        do {
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(favoriteStocks)
//            UserDefaults.standard.set(data, forKey: "favoritesList")
//
//        } catch {
//
//        }
//
//
//    }
//    func moveFavorite(from source:IndexSet,to destination:Int){
//        let reversedSource=source.sorted()
//        for index in reversedSource.reversed(){
//            favoriteStocks.insert(favoriteStocks.remove(at:index),at:destination)
//        }
//        do {
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(favoriteStocks)
//            UserDefaults.standard.set(data, forKey: "favoritesList")
//
//        } catch {
//
//        }
//    }
//}
//
//

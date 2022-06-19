//
//  ContentView.swift
//  StocksHub
//
//  Created by Param Thakker on 4/6/22.
//

import SwiftUI
import Highcharts

struct ContentView: View {
    @State var countries = ["TSLA","MSFT","FB","GOOGL","NVDA"]
    @State var favoriteStocks:[FavoriteComp]=refreshFavorites()
    @State var portfolioStocks:[PortfolioComp]=refreshPortfolio()
    @State var totalCash:Double=refreshWalletBalance()
    @State var marketValueOfStocks:Double
    @State var searchText=""
    @State var showDetails=true
    @StateObject var searchModel=SearchModel()
    @StateObject var lpModel=LatestPriceModel()
    @State var favoritesTickerList:[String]
    @State var portfolioTickerList:[String]
    @State private var currentValue = 0.0
    @State private var hasTimeElapsed = false
    let timer = Timer.publish(every: 0.09, on: .main, in: .common).autoconnect()
    private func delay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
               hasTimeElapsed = true
           }
        
       }
    var body: some View {
        
        
       // while (hasTimeElapsed==false) {
        if (hasTimeElapsed==false){
            ProgressView("Fetching Data…")
                .onAppear(perform: delay)
        //}
        }
        else{
     
            

           NavigationView {
               
               List{
                   if (searchText.count>0){
                       ForEach(searchModel.results
                               , id:\.self) {
                           search in NavigationLink(destination: Details(ticker:search.displaySymbol,favoriteStocks:favoriteStocks,portfolioStocks:portfolioStocks,shares: 0,avgCost:0,strongBuyData:[],buyData: [],holdData: [],sellData:[],strongSellData:[], toOpenIndex: 2,newsSource:" ",newsSummary:" ",newsHeadline:" ",newsURL:" ",newsDate:0.0,toastMessage: "")){
                           VStack(alignment: .leading) {
                               
                               Text(search.displaySymbol).bold()
                               Text(search.description)
                               
                           }
                           }
                       }
                   }
                   else{
                
                   Text(getDate()).foregroundColor(Color.gray)
                       .font(.title.bold())
                       .multilineTextAlignment(.leading)


                   Section(header:Label("Portfolio", systemImage: "")
                    .font(.headline)
                    .foregroundColor(Color.gray)){
                        
                        
                        
//                        HStack {
//
//                            VStack(alignment: .leading){
//                                Text("Net Worth").font(.system(size:23))
//
//                                Text("$\(totalCash+marketValueOfStocks, specifier: "%.2f")").font(.system(size:22)).bold()
//                            }
//
//                            Spacer()
//                            VStack(alignment: .leading){
//                            Text("Cash Balance").font(.system(size:23))
//
//                                Text("$\(totalCash, specifier: "%.2f")").font(.system(size:22)).bold()
//                            }
//
//                        }
                        
                        walletView()
                        
                        
//
                        portfolioView()
//        
//                        ForEach(portfolioStocks, id: \.self) {                  stock in
//                            NavigationLink(destination: Details(ticker:stock.stockTicker,favoriteStocks:favoriteStocks,portfolioStocks:portfolioStocks,shares: 0,avgCost:0,strongBuyData:[],buyData: [],holdData: [],sellData:[],strongSellData:[], toOpenIndex: 2,newsSource:" ",newsSummary:" ",newsHeadline:" ",newsURL:" ",newsDate:0.0,toastMessage: "")){
//                            HStack{
//                                VStack(alignment: .leading){
//                                    Text(stock.stockTicker).bold().font(.system(size: 22))
//                                    if (stock.numShares>1){
//                                    Text(String(stock.numShares) + " shares").font(.system(size: 15)).font(.caption).foregroundColor(Color.gray)
//                                    }
//                                    else{
//                                        Text(String(stock.numShares) + " share").font(.system(size: 15)).font(.caption).foregroundColor(Color.gray)
//                                    }
//
//                                }
//                                Spacer()
//                                VStack(alignment: .trailing){
//                                    Text("$\(stock.latestStockPrice * Double(stock.numShares), specifier: "%.2f")").bold()
//
//                                    if (((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares))<0){
//                                        HStack{
//                                            Image(systemName: "arrow.down.forward").foregroundColor(Color.red)
//                                        Text("$\(((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares)), specifier: "%.2f") (\(      ((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares))*100/(stock.avgPrice*Double(stock.numShares)), specifier: "%.2f")%)").foregroundColor(Color.red)
//                                        }
//                                    }
//                                    else if (((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares))>0){
//                                        HStack{
//                                            Image(systemName: "arrow.up.forward").foregroundColor(Color.green)
//                                        Text("$\(((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares)), specifier: "%.2f") (\(      ((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares))*100/(stock.avgPrice*Double(stock.numShares)), specifier: "%.2f")%)").foregroundColor(Color.green)
//                                        }
//                                    }
//                                    else{
//                                        HStack{
//                                            Image(systemName: "minus").foregroundColor(Color.gray)
//                                        Text("$\(((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares)), specifier: "%.2f") (\(      ((stock.latestStockPrice-stock.avgPrice)*Double(stock.numShares))*100/(stock.avgPrice*Double(stock.numShares)), specifier: "%.2f")%)").foregroundColor(Color.gray)
//                                        }
//                                    }
//
//
//                                }
//
//                            }
//                        }
//                                       }
//
//
//                    .onMove(perform: movePortfolio)
//
//
//                        .padding(/*@START_MENU_TOKEN@*/.horizontal, 12.0/*@END_MENU_TOKEN@*/)


                   }

                   Section(header:Label("Favorites",systemImage: "")
                    .font(.headline)
                    .foregroundColor(Color.gray)){
 

                        favView()

                    

                   }
                   Label("   Powered by [Finnhub.io](https://finnhub.io/)",systemImage: "")
                       .padding(.leading)
                       .foregroundColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)
               }

               }
             
               .navigationTitle("Stocks")
               .navigationBarItems(trailing:EditButton())

                }.searchable(text: $searchText)
            .onChange(of: searchText){
                value in
                searchModel.fetch(ticker:value)
               }
            .onAppear{
//                if (UserDefaults.standard.object(forKey: "favoritesList")==nil){
//                    favoriteStocks=[]
//                }
//
//               else if let data = UserDefaults.standard.data(forKey: "favoritesList") {
//                    do {
//                        let decoder = JSONDecoder()
//                        favoriteStocks = try decoder.decode([FavoriteComp].self, from: data)
//                        for index in 0 ..< favoriteStocks.count {
//                            favoritesTickerList.append(favoriteStocks[index].stockTicker)
//                        }
//
//                    } catch {
//
//                    }
//                }
//                if (UserDefaults.standard.object(forKey: "portfolioList")==nil){
//                    portfolioStocks=[]
//                }
//                else if let data = UserDefaults.standard.data(forKey: "portfolioList") {
//                    do {
//                        let decoder = JSONDecoder()
//                        portfolioStocks = try decoder.decode([PortfolioComp].self, from: data)
//                        for index in 0 ..< portfolioStocks.count {
//                            portfolioTickerList.append(portfolioStocks[index].stockTicker)
//                        }
//
//
//
//                    } catch {
//
//                    }
//                }

                
//                let set1:Set<String> = Set(favoritesTickerList)
//                let set2:Set<String> = Set(portfolioTickerList)
//                let set3:Set<String>=set1.union(set2)
//
//                for ticker in set3 {
//
//                    lpModel.fetch(stockName: ticker)
//                    for index in 0 ..< portfolioStocks.count {
//
//                        if (portfolioStocks[index].stockTicker==ticker){
//                            var comp=portfolioStocks[index]
//                            comp.latestStockPrice=lpModel.currentPrice
//                            portfolioStocks[index]=comp
//
//                        }
//                    }
//
//                    for index in 0 ..< favoriteStocks.count {
//                        if (favoriteStocks[index].stockTicker==ticker){
//                            var comp=favoriteStocks[index]
//                            comp.stockPrice=lpModel.currentPrice
//                            comp.change=lpModel.change
//                            comp.percentChange=lpModel.changePercent
//                            favoriteStocks[index]=comp
//                        }
//                    }
//
//                }
                
      
//                if (UserDefaults.standard.object(forKey: "totalCash")==nil){
//
//                    UserDefaults.standard.set(25000.00, forKey: "totalCash")
//                }
//                else{
//                    totalCash = UserDefaults.standard.double(forKey: "totalCash") ?? 25000.00
//                }
    
               // calculateMarketValue()
                
            }

               .accentColor(Color.black)
               .ignoresSafeArea()
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
    func getDate()->String{
        let date=Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let calendar=Calendar.current
        let day=calendar.component(.day, from: date)
        let month=dateFormatter.string(from:date)
        let year=calendar.component(.year, from: date)
        let formattedDate="\(month) \(day), \(year)"
        return formattedDate
        
        
    }
    
   
    
}


func refreshFavorites()->[FavoriteComp]{
    var favoriteStocks:[FavoriteComp]=[]
    if (UserDefaults.standard.object(forKey: "favoritesList")==nil){
        //favoriteStocks=[]
        return []
    }
    
   else if let data = UserDefaults.standard.data(forKey: "favoritesList") {
        do {
            let decoder = JSONDecoder()
            favoriteStocks = try decoder.decode([FavoriteComp].self, from: data)
            if (favoriteStocks.isEmpty || favoriteStocks.count==0){
                return []
            }
//            for index in 0 ..< favoriteStocks.count {
//                favoritesTickerList.append(favoriteStocks[index].stockTicker)
//            }

        } catch {
            
        }
       
    }
    print(favoriteStocks)
    return favoriteStocks
}

func refreshPortfolio()->[PortfolioComp]{
    var portfolioStocks:[PortfolioComp]=[]
    if (UserDefaults.standard.object(forKey: "portfolioList")==nil){
        //portfolioStocks=[]
        return portfolioStocks
    }
    else if let data = UserDefaults.standard.data(forKey: "portfolioList") {
        do {
            let decoder = JSONDecoder()
            portfolioStocks = try decoder.decode([PortfolioComp].self, from: data)
//            for index in 0 ..< portfolioStocks.count {
//                portfolioTickerList.append(portfolioStocks[index].stockTicker)
//            }
          
            

        } catch {
            
        }
       
    }
    return portfolioStocks
}


func refreshWalletBalance()->Double{
    var balance:Double=0
    if (UserDefaults.standard.object(forKey: "totalCash")==nil){
       
        UserDefaults.standard.set(25000.00, forKey: "totalCash")
    }
    else{
        balance = UserDefaults.standard.double(forKey: "totalCash") ?? 25000.00
    }
    return balance
}

struct ContentView_Previews: PreviewProvider {


    static var previews: some View {

        ContentView(favoriteStocks: [FavoriteComp(ticker: "TSLA",name: "TSLA Inc",price: 978.2,priceChange: 10.5,percentChange: 2.3)],portfolioStocks: [PortfolioComp(ticker: "TSLA",shares: 3,avg: 978.2,latestprice: 956.4,stockChange: 4.5,stockPercentChange: 1.2)],totalCash: 25000,marketValueOfStocks:0,favoritesTickerList: [],portfolioTickerList: [])

    }
}


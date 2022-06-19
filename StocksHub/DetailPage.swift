//
//  DetailPage.swift
//  StocksHub
//
//  Created by Param Thakker on 4/16/22.
//

import Foundation
import SwiftUI
import Highcharts
import SimpleToast

struct Details:View{
   
    @State var ticker:String
    @State var favoriteStocks:[FavoriteComp]
    @State var portfolioStocks:[PortfolioComp]
    @State private var existsInPortfolio:Bool=false
    @State private var existsInFavorite:Bool=false
    @State var shares:Int
    @State var avgCost:Double
    @StateObject var newsModel=NewsModel()
    @StateObject var lpModel=LatestPriceModel()
    @StateObject var metadataModel=MetadataModel()
    @StateObject var peersModel=PeersModel()
    @StateObject var sentimentsModel=SentimentsModel()
    @StateObject var recModel=RecommendationsModel()
    @State var strongBuyData:[Int]
    @State var buyData:[Int]
    @State var holdData:[Int]
    @State var sellData:[Int]
    @State var strongSellData:[Int]
    @State var showingSheet = false
    @State var showingNewsSheet = false
    @State var toOpenIndex:Int
    @State var newsSource:String
    @State var newsSummary:String
    @State var newsHeadline:String
    @State var newsURL:String
    @State var newsDate:Double
    @State var toastMessage:String
    @State private var showToast: Bool = false
    @State private var addFav: Bool = false
    @State private var removeFav: Bool = false
    @State var refreshDetailPage:Bool=false
    let toastOptions=SimpleToastOptions(alignment:.bottom,hideAfter: 3)
    

    
    var body: some View{
        ScrollView{
            if(metadataModel.isFetchingData || lpModel.isFetchingData || peersModel.isFetchingData || newsModel.isFetchingData || sentimentsModel.isFetchingData){
                ProgressView("Fetching data...").padding(.top, 300.0).onAppear{
                    
                    
                    for index in 0 ..< portfolioStocks.count {
                        if (portfolioStocks[index].stockTicker==ticker){
                            existsInPortfolio=true
                            shares=portfolioStocks[index].numShares
                            avgCost=portfolioStocks[index].avgPrice

                        }
                    }
                        for index in 0 ..< favoriteStocks.count {
                            if (favoriteStocks[index].stockTicker==ticker){
                                existsInFavorite=true
          
                            }
                        }
                    
                    metadataModel.fetch(stockName: ticker)
                    lpModel.fetch(stockName: ticker)
                    peersModel.fetch(stockName: ticker)
                    newsModel.fetch(stockName: ticker)
                    sentimentsModel.fetch(stockName: ticker)

                }
            
            }
            else{
                VStack(){
                     HStack{
                         Text(metadataModel.companyName).font(.system(size:18)).foregroundColor(Color.gray)
                     Spacer()
                       
                     AsyncImage(
                        url:URL(string: metadataModel.logolink),
                                 content: { image in
                                     image.resizable()
                                          .aspectRatio(contentMode: .fit)
                                          .frame(maxWidth: 50, maxHeight: 50)
                                 },
                                 placeholder: {
                                     ProgressView()
                                 }
                             )
            
                     }.padding()
                     
                     .onAppear{
                         self.newsSource=newsModel.news[0].source
                         self.newsSummary=newsModel.news[0].summary
                         self.newsHeadline=newsModel.news[0].headline
                         self.newsURL=newsModel.news[0].url
                         self.newsDate=newsModel.news[0].datetime
                         print("$$$$$$$$$$$$")
                         print(toastMessage)
                         
                     }
               
                    HStack(alignment:.bottom){
                         Text("$\(lpModel.currentPrice, specifier: "%.2f")").bold().font(.system(size: 35))
                     Spacer()
                         if (lpModel.change>0){
                             HStack{
                                 Image(systemName: "arrow.up.forward").foregroundColor(Color.green)
                                 Text("\(lpModel.change, specifier: "%.2f") (\(lpModel.changePercent,specifier: "%.2f")%)").font(.system(size: 25)).foregroundColor(Color.green)
                             }
                         }
                         else if (lpModel.change<0){
                             HStack{
                                 Image(systemName: "arrow.down.forward").foregroundColor(Color.red)
                                 Text("\(lpModel.change, specifier: "%.2f") (\(lpModel.changePercent,specifier: "%.2f")%)").font(.system(size: 25)).foregroundColor(Color.red)
                             }
                         }
                         else{
                             HStack{
                                 Image(systemName: "minus").foregroundColor(Color.gray)
                                 Text("\(lpModel.change, specifier: "%.2f") (\(lpModel.changePercent,specifier: "%.2f")%)").font(.system(size: 25)).foregroundColor(Color.gray)
                             }
                         }
                         Spacer()
                            
                     }.padding()
                
                Group{
                TabView{
                    DailyView(ticker: ticker,change:lpModel.change,time:lpModel.time).tabItem{
                        Image(systemName:"chart.xyaxis.line")
                        Text("Hourly")
                    }
                
                    WebView(ticker: ticker).tabItem{
                        Image(systemName:"clock.fill")
                        Text("Historical")
                    }
                }.frame(width:400,height: 450)
                        .background(Color.red)

                    
                    HStack{
                    Text("\nPortfolio").bold().font(.system(size: 20))
                      Spacer()
                    }.padding()
                    
                    
                    
                    HStack(alignment: .center) {

                        
                        if (refreshDetailPage){
                            portfolioSection(ticker: ticker, currentPrice: lpModel.currentPrice,boolTemp:true)
                        }
                            
                        else{
                            portfolioSection(ticker: ticker, currentPrice: lpModel.currentPrice,boolTemp:true)

                        }
//                  Text("\t")
                        
                    
                        Spacer()
                        Button(action: {
                            showingSheet.toggle()
                        }, label: {
                            Text("Trade")
                                .frame(width: 175, height: 50)
                                .foregroundColor(Color.white)
                                .background(Color.green)
                                .cornerRadius(70)
                        })
                        .buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $showingSheet) {
                            TradeSheet(ticker: ticker,companyName:metadataModel.companyName,currentPrice:lpModel.currentPrice,toastMessage:"",refreshDetailPage:$refreshDetailPage,change:lpModel.change,percentChange:lpModel.changePercent)
                        }
                       

                    }.padding()
//                        .simpleToast(isShowing: self.$showToast, options: toastOptions, content: {
//                            Text(self.toastMessage).padding().foregroundColor(Color.white).background(Color.gray).cornerRadius(20).frame(width: 350)
//                        })
                    
//                        .toast(isShowing: $addFav, text: Text("Adding \(ticker) to Favorites"))
//                        .toast(isShowing: $removeFav, text: Text("Removing \(ticker) from Favorites"))
                        
      
//                if (existsInPortfolio || refreshDetailPage){
//                    Text("\n\n\n\n")
//                }
//                else{
//                    Text("\n\n")
//                }
//
//                Text("Stats\n").bold().font(.system(size: 20)).multilineTextAlignment(.leading).padding(.trailing, 370.0)
                    
                    HStack{
                    Text("\nStats").bold().font(.system(size: 20))
                        Spacer()
                    }.padding()
                
                HStack{
                    VStack(alignment:.leading){
                        Text("High Price:").font(.system(size:14)).bold() + Text("   $\(lpModel.highPrice, specifier: "%.2f")\n")
                            .font(.system(size: 14))
                        Text("Low Price:").font(.system(size:14)).bold() + Text("   $\(lpModel.lowPrice, specifier: "%.2f")")
                            .font(.system(size: 14))
                  
                    
                    }
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Open Price:").font(.system(size:14)).bold() + Text("   $\(lpModel.openPrice, specifier: "%.2f")\n")
                            .font(.system(size: 14))
                        Text("Prev. Close:").font(.system(size:14)).bold() + Text("   $\(lpModel.prevClose, specifier: "%.2f")")
                            .font(.system(size: 14))

                    
                    }
                    Spacer()
                }.padding()
                
                
                
                    HStack{
                        Text("About").bold().font(.system(size: 20))
                        Spacer()
                    }.padding()
                    
                    
                HStack{

                    VStack(alignment:.leading, spacing: 6){
                        Text("IPO Start Date:").bold().font(.system(size: 15))
                        Text("Industry:").bold().font(.system(size: 15))
                        Text("Webpage:").bold().font(.system(size: 15))
                        Text("Company Peers:").bold().font(.system(size: 15))
                    }
                    Spacer()
                    VStack(alignment: .leading,spacing: 6){
                        Text(metadataModel.ipoDate).font(.system(size: 15))
                        Text(metadataModel.industry).font(.system(size: 15))
                        Link(String(metadataModel.url), destination: (URL(string:metadataModel.url) ?? URL(string:"https://abc.xyz"))!).foregroundColor(Color.blue).font(.system(size:15))
                        
                        
                        ScrollView(.horizontal) {
                                    LazyHStack {
                                        
                                        ForEach(0..<peersModel.peers.count, id:\.self) {index in
                                        
                                            
                                            NavigationLink(destination: Details(ticker:peersModel.peers[index],favoriteStocks:favoriteStocks,portfolioStocks:portfolioStocks,shares: 0,avgCost:0,strongBuyData:[],buyData: [],holdData: [],sellData:[],strongSellData:[], toOpenIndex: 2,newsSource:" ",newsSummary:" ",newsHeadline:" ",newsURL:" ",newsDate:0.0, toastMessage: "")){

                                            if (index==peersModel.peers.count-1){
                                                Text(peersModel.peers[index]).font(.system(size:15)).foregroundColor(Color.blue)
                                            }
                                            else{
                                            
                                                Text(peersModel.peers[index] + ",").font(.system(size:15)).foregroundColor(Color.blue)
                                            }
                                            }
                                        }
                                    }
                                }

                    }
                    Spacer()
                }.padding()
                
            
//                Text("\nInsights").bold().font(.system(size: 20)).multilineTextAlignment(.leading).padding(.trailing, 340.0)
                    
                    
                }
                    HStack{
                    Text("Insights").bold().font(.system(size: 20))
                        Spacer()
                    }.padding()
                Text("Social Sentiments").bold().font(.system(size: 20))
                
                
                Group{
                HStack(alignment: .top){
                    VStack(alignment:.leading){
                        Text("")
                        Divider()
                        Text("\(metadataModel.companyName)").bold().font(.system(size: 15)).frame(height: 50)
                        Divider()
                        Text("Total\nMentions ").bold().font(.system(size: 15)).frame(height: 50)
                        Divider()
                        Text("Positive\nMentions ").bold().font(.system(size: 15)).frame(height: 50)
                        Divider()
                        Text("Negative\nMentions ").bold().font(.system(size: 15)).frame(height: 50)
                        Divider()
                      
                    }
                    Spacer()
                    VStack(alignment:.leading){
                        Text("")
                        Divider()
                        Text("Reddit").bold().font(.system(size: 15)).frame(height: 50)
                        Divider()
                        Text(String(sentimentsModel.redditTotalMentions)).font(.system(size: 15)).frame(height: 50)
                        Divider()
                        
                        Text(String(sentimentsModel.redditPositiveMentions)).font(.system(size: 15)).frame(height: 50)
                        Divider()
                        Text(String(sentimentsModel.redditNegativeMentions)).font(.system(size: 15)).frame(height: 50)
                        Divider()
                        
                    }
                    Spacer()
                    VStack(alignment:.leading){
                        Text("")
                        Divider()
                        Text("Twitter").bold().font(.system(size: 15)).frame(height: 50)
                        Divider()
                        Text(String(sentimentsModel.twitterTotalMentions)).font(.system(size: 15))
                            .frame(height: 50)
                        Divider()
                        Text(String(sentimentsModel.twitterPositiveMentions)).font(.system(size: 15)).frame(height: 50)
                        Divider()
                        Text(String(sentimentsModel.twitterNegativeMentions)).font(.system(size: 15)).frame(height: 50)
                        Divider()
                        //Text("\n")
                        
                    }
                }.padding()
 
               
                    RecommendationsView(ticker: ticker)
                        .frame(width: 420, height: 550)
                  
                    EPSView(ticker:ticker)
                        .frame(width: 420, height: 420)
     
                
                    HStack{
                    Text("News").bold().font(.system(size: 20))
                        Spacer()
                    }.padding()
                    
                    VStack(alignment: .leading){
                        AsyncImage(
                           url:URL(string: newsModel.news[0].image),
                                    content: { image in
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(maxWidth:370,maxHeight:200)
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                            .cornerRadius(20)
                                        
                                        
//                                        image.resizable()
//                                             .cornerRadius(20)
//                                             .frame(maxWidth: 400, maxHeight: 260)
                                    },
                                    placeholder: {
                                        ProgressView()
                                    }
                        )
                        HStack{
                            Text(newsModel.news[0].source).foregroundColor(Color.gray)
                                .font(.footnote.bold())
                                .multilineTextAlignment(.leading)
                            Text(getTimeDifference(prevTime:newsModel.news[0].datetime))  .font(.footnote.bold()).foregroundColor(Color.gray)
                            Spacer()
                        }
                        Text(newsModel.news[0].headline).bold()

                    }.padding()
                        .buttonStyle(BorderlessButtonStyle())
                        .onTapGesture{
                            self.newsSource=newsModel.news[0].source
                            self.newsSummary=newsModel.news[0].summary
                            self.newsHeadline=newsModel.news[0].headline
                            self.newsURL=newsModel.news[0].url
                            self.newsDate=newsModel.news[0].datetime
                            self.showingNewsSheet.toggle()
                          
                        }.sheet(isPresented: $showingNewsSheet) {
//                            NewsSheet(source:self.newsSource,summary:self.newsSummary,headline:self.newsHeadline,weburl:self.newsURL,time:self.newsDate)
                            NewsSheet(source:newsModel.news[0].source,summary:newsModel.news[0].summary,headline:newsModel.news[0].headline,weburl:newsModel.news[0].url,time:newsModel.news[0].datetime)
                        }
                    Divider()
                
                ForEach(1..<newsModel.news.count, id:\.self) {index in
                    
                    
                    HStack(alignment: .top){
                        VStack(alignment: .leading){
                            HStack{
                                Text(newsModel.news[index].source).foregroundColor(Color.gray)
                                    .font(.footnote.bold())
                                    .multilineTextAlignment(.leading)
                                Text(getTimeDifference(prevTime:newsModel.news[index].datetime)).foregroundColor(Color.gray).font(.footnote.bold())
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            Text(newsModel.news[index].headline).bold()
                            
                            
                        }
                        AsyncImage(
                           url:URL(string: newsModel.news[index].image),
                                    content: { image in
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(maxWidth:80,maxHeight:80)
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                            .cornerRadius(20)
                                        
                                        
//                                            .scaledToFill()
//                                            .frame(maxWidth:370,maxHeight:200)
//                                            .aspectRatio(contentMode: .fill)
//                                            .clipped()
//                                            .cornerRadius(20)
//                                        image.resizable()
//                                            .cornerRadius(15)
//                                             .frame(maxWidth: 80, maxHeight: 80)
                                    },
                                    placeholder: {
                                        ProgressView()
                                    }
                        )
                        Divider()
    
                    }.padding()
                        .buttonStyle(BorderlessButtonStyle())
                    .onTapGesture{
         
                        self.newsSource=newsModel.news[index].source
                        self.newsSummary=newsModel.news[index].summary
                        self.newsHeadline=newsModel.news[index].headline
                        self.newsURL=newsModel.news[index].url
                        self.newsDate=newsModel.news[index].datetime
                        self.showingNewsSheet.toggle()
                   
                        print(index)
                        
                    }.sheet(isPresented: $showingNewsSheet) {
                      
//                        NewsSheet(source:self.newsSource,summary:self.newsSummary,headline:self.newsHeadline,weburl:self.newsURL,time:self.newsDate)
                        
                        NewsSheet(source:newsModel.news[0].source,summary:newsModel.news[0].summary,headline:newsModel.news[0].headline,weburl:newsModel.news[0].url,time:newsModel.news[0].datetime)
                    }
                        

                }
                    
                    

                
                

                Spacer()
                }
 
            }            .padding(.horizontal,25.0)
            .navigationTitle(ticker)
           

                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                            if (!existsInFavorite){
                                toastMessage="Adding \(ticker) to Favorites"
                                self.addFav.toggle()
                                addToFavorites()
                            }
                            else{
                                toastMessage="Removing \(ticker) from Favorites"
                                removeFromFavorites()
                                self.removeFav.toggle()
                            }
                            existsInFavorite.toggle()
                            self.showToast.toggle()
                           
                            
                        }, label: {
                           
                            if(existsInFavorite){
                            Image(systemName: "plus.circle.fill")
                            }
                            else{
                                Image(systemName: "plus.circle")
                            }

                        })
                        
                    };
                }
             
        }
 
    }.simpleToast(isShowing: self.$showToast, options: toastOptions, content: {
        Text(self.toastMessage).padding().clipShape(Capsule()).foregroundColor(Color.white).background(Color.gray).cornerRadius(20).frame(width: 350)//.clipShape(Capsule)
    })

    }
    func isLoading()->Bool{
        return metadataModel.isFetchingData || lpModel.isFetchingData || peersModel.isFetchingData || newsModel.isFetchingData || sentimentsModel.isFetchingData
    }
    func getTimeDifference(prevTime:Double)->String{
        let time1 = Date(timeIntervalSince1970: Double(prevTime))
        let time2 = Date(timeIntervalSince1970:Double(Int(Date().timeIntervalSince1970)))
        let difference = Calendar.current.dateComponents([.second], from: time1, to: time2)
        let duration = difference.second
        let val=duration!
        let hours=(val%86400)/3600
        let mins=(val%3600)/60
        return( String(hours) + " hr, " + String(mins) + " min")
    }
    
    
    func removeFromFavorites() {
        
        if (UserDefaults.standard.object(forKey: "favoritesList")==nil){
           return
        }

        if let data = UserDefaults.standard.data(forKey: "favoritesList") {
        do {
            let decoder = JSONDecoder()
            var favoriteStocks = try decoder.decode([FavoriteComp].self, from: data)
            for index in 0 ..< favoriteStocks.count {
                if (favoriteStocks[index].stockTicker==ticker){
                    favoriteStocks.remove(at: index)
                    
             }
            }
            print("#############")
            print(favoriteStocks)
            
            if (favoriteStocks.isEmpty || favoriteStocks.count==0){
                UserDefaults.standard.removeObject(forKey: "favoritesList")
            }
            else{
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(favoriteStocks)
                UserDefaults.standard.set(data, forKey: "favoritesList")

            } catch { }
            }
            

        } catch {}
        }
        

    }
    
    func addToFavorites(){
        let favComp=FavoriteComp(ticker:ticker,name:metadataModel.companyName,price:lpModel.currentPrice,priceChange:lpModel.change,percentChange:lpModel.changePercent)
        if (UserDefaults.standard.object(forKey: "favoritesList")==nil){
            let favoritesList=[favComp]
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(favoritesList)
                    UserDefaults.standard.set(data, forKey: "favoritesList")

                } catch {}
        }
        else{
            if let data = UserDefaults.standard.data(forKey: "favoritesList") {
            do {
                let decoder = JSONDecoder()
                var favoriteStocks = try decoder.decode([FavoriteComp].self, from: data)
                favoriteStocks.append(favComp)
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(favoriteStocks)
                    UserDefaults.standard.set(data, forKey: "favoritesList")

                } catch {}
            } catch {}
            }
        }

    }
}


//
//struct Details_Previews: PreviewProvider {
//    static var previews: some View {
//        let ticker="TSLA"
//        Details(ticker: ticker)
//
//    }
//}


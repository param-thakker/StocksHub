//
//  HistoricalCharts.swift
//  StocksHub
//
//  Created by Param Thakker on 4/21/22.


import Foundation
import SwiftUI
import Highcharts
import WebKit

//
//
//struct HistData:View{
//
//    @StateObject var histModel=HistoricalDataModel()
//    @State var ticker:String
//
//    var body: some View{
//        if (histModel.isFetchingData){
//
//            ProgressView().onAppear{
//                histModel.fetch(stockName: ticker)
//            }
//        }
//        else{
//            //html()
//
//            WebView(ticker: ticker,showLoading: true)
//                  .frame(minWidth:350, maxWidth: .infinity, minHeight: 350, maxHeight: .infinity)
//
//
//
////            WebView(text: $text, showLoading: $showLoading,combined: histModel.combinedData)
////                .frame(minWidth:350, maxWidth: .infinity, minHeight: 350, maxHeight: .infinity)
//
//        }
//
//    }
//}

//
//struct html: View {
//    @State var text=""
//
//  var body: some View {
//
//    WebView(text: $text)
//          .frame(minWidth:350, maxWidth: .infinity, minHeight: 350, maxHeight: .infinity)
//  }
//}








struct WebView: UIViewRepresentable {
   @State var ticker:String
   //@Binding var showLoading:Bool=true
    var webView=WKWebView()
      class WebViewCoordinator: NSObject,WKNavigationDelegate{

          var didStart: ()-> Void
          var didFinish: ()-> Void


          init(didStart:@escaping ()->Void={},didFinish:@escaping()->Void={}){
              self.didStart=didStart
              self.didFinish=didFinish
          }
          func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
              didStart()
          }
          func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

              didFinish()
          }
      }
 
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }

  func updateUIView(_ uiView: WKWebView, context: Context) {

      if let indexURL=Bundle.main.url(forResource: "index", withExtension: "html"){
          uiView.loadFileURL(indexURL, allowingReadAccessTo: indexURL)
          uiView.frame.size.height = 1900

          uiView.frame.size.width = 450

      }

  }
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(didStart: {
            //showLoading=true
        }, didFinish: {
            //showLoading=false
            //print("makeHistoricalChart(\(self.combined))")
            //self.webView.evaluateJavaScript("createHistoricalCharts(\(self.ticker))")
            
        }
                           
        )}
}






//
//struct html:UIViewRepresentable{
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        <#code#>
//    }
//
//
//    func makeUIView(context: Context) -> WKWebView{
//        weak var webView: WKWebView!
//        if let indexURL = Bundle.main.url(forResource: "index",
//                                          withExtension: "html") {
//
//            // 2
//           loadFileURL(indexURL,
//                                     allowingReadAccessTo: indexURL)
//        }
//    }
//    //@IBOutlet weak var webView: WKWebView!
////    var body: some View{
////      Text("He")
//
////webView1.loadHTMLString("<html><body><p>Hello!</p></body></html>", baseURL: nil)
////}
//}
//
//
//
//
//
//
//struct html_Previews:PreviewProvider {
//    static var previews: some View {
//        html()
//
//    }
//}








//
//import SwiftUI
//import WebKit
//
//
//struct HistData:View{
//    @State var text=""
//    @State private var showLoading:Bool=false
//struct HistoricalChartsData:Hashable,Codable{
//    let o:[Double]
//    let h:[Double]
//    let l:[Double]
//    let c:[Double]
//    let v:[Int]
//    let t:[Int]
//}
//
//class HistoricalDataModel:ObservableObject {
//    @Published var openPriceData:[Double]=[]
//    @Published var highPriceData:[Double]=[]
//    @Published var lowPriceData:[Double]=[]
//    @Published var currentPriceData:[Double]=[]
//    @Published var volumeData:[Int]=[]
//    @Published var timeData:[Int]=[]
//    @Published var combinedData:[[Any]]=[]
//    @Published var isFetchingData: Bool = true
//    func fetch()  {
//
//        guard let url=URL(string:"https://financehubbackend.wl.r.appspot.com/api/v1.0.0/histcharts/TSLA/date/05-01-2020") else{
//            return
//        }
//
//        let task=URLSession.shared.dataTask(with: url){[weak self]
//            data,_,error in guard let data = data, error==nil else {
//                return
//            }
//
//
//            do{
//                let histData=try JSONDecoder().decode(HistoricalChartsData.self, from: data)
//                self!.openPriceData=histData.o
//                self!.highPriceData=histData.h
//                self!.lowPriceData=histData.l
//                self!.currentPriceData=histData.c
//                self!.volumeData=histData.v
//                self!.timeData=histData.t
//
//
//                for index in 0 ..< self!.openPriceData.count{
//                    self!.combinedData.append([ self!.openPriceData[index], self!.highPriceData[index], self!.lowPriceData[index], self!.currentPriceData[index], self!.volumeData[index], self!.timeData[index]])
//                }
//                self!.isFetchingData = false
//                //print(self!.combinedData)
//
//
//            }
//            catch{
//                print(error)
//            }
//        }
//        task.resume()
//    }
//}
//
//
//    @StateObject var histModel=HistoricalDataModel()
//
//    var body: some View{
//        if (histModel.isFetchingData){
//
//            ProgressView().onAppear{
//                histModel.fetch()
//            }
//        }
//        else{
//            WebView(text: $text, showLoading: $showLoading,combined: histModel.combinedData)
//                .frame(minWidth:350, maxWidth: .infinity, minHeight: 350, maxHeight: .infinity)
//
//        }
//
//    }
//}
//
//



//
//
//
////
////
////            //return WebViewCoordinator()
////
//////
////        })
////    }
//
//
//}
//
//
//
//struct html_Previews: PreviewProvider {
//  static var previews: some View {
//    HistData()
//  }
//}

//
//  NewsSheet.swift
//  StocksHub
//
//  Created by Param Thakker on 4/30/22.
//

import Foundation
import SwiftUI
import SheetKit


struct NewsSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var source: String
    @State var summary: String
    @State var headline: String
    @State var weburl: String
    @State var time:Double
    
    var body: some View {
        NavigationView{
        VStack {
            Text(getDate())
                .padding(.trailing, 275.0).foregroundColor(Color.gray).opacity(1.5)
         
            Divider()
            VStack(alignment: .leading){
                Text(headline).font(.headline).bold()
                Text(summary).font(.body).font(.system(size: 12))
                HStack(alignment: .center){
                    Text("For more details click").font(.system(size: 14)).foregroundColor(Color.gray).bold()
                    Link("here", destination: (URL(string:weburl) ?? URL(string:"https://abc.xyz"))!).font(.system(size: 14))
                }
               
                    
                    HStack{
                        
                        
                        
            Button(action:{
                let newsHeadline = headline.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                
                
                let newsLink = weburl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

                
//                Text("For more details click").font(.system(size: 14)).foregroundColor(Color.gray).bold()
//                Link("here", destination: (URL(string:weburl) ?? URL(string:"https://abc.xyz"))!).font(.system(size: 14))
                
                guard let tweetShareURL = URL(string:"https://twitter.com/intent/tweet?text=\(newsHeadline!)&url=\(newsLink!)"),
                      UIApplication.shared.canOpenURL(tweetShareURL) else {
                               return}
                UIApplication.shared.open(tweetShareURL)
            
            }){
                Image("TwitterLogo")
                    .resizable().frame(width: 60, height: 60)
                    .buttonStyle(BorderlessButtonStyle())
                
            }
                        
                        Button(action:{
                            let newsHeadline = headline.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                            
                            
//                            Text("For more details click").font(.system(size: 14)).foregroundColor(Color.gray).bold()
//                            Link("here", destination: (URL(string:weburl) ?? URL(string:"https://abc.xyz"))!).font(.system(size: 14))
                            let newsLink = weburl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

                            
                            
//                            guard let tweetShareURL = URL(string:"https://twitter.com/intent/tweet?text=\(newsHeadline!)&url=\(newsLink!)"),
//                                  UIApplication.shared.canOpenURL(tweetShareURL) else {
//                                           return}
                            
                            
                            guard let socialPlugInLink = URL(string:"https://www.facebook.com/sharer/sharer.php?u=\(newsLink!)"),
                             UIApplication.shared.canOpenURL(socialPlugInLink) else {
                                      return
                   }
                       UIApplication.shared.open(socialPlugInLink)
                   
                   }){
                       Image("facebookLogo")
                           .resizable()
                           .frame(width: 60, height: 60)
                       
                   }
                
                
                
    
            }
           
            Spacer()
        }.navigationTitle(source)
        .navigationBarItems(trailing: Button(action: {
            SheetKit().dismissAllSheets(animated:false)
        }, label: {
            Image(systemName: "xmark").foregroundColor(Color.black)
        }))
        }
        
    }
}
    func getDate()->String{
        let date = Date(timeIntervalSince1970: time)
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



struct testSheet: View {
    @State private var showingSheet = false

    var body: some View {
        Button("Show Sheet") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            NewsSheet(source: "", summary: "",headline: "",weburl: "",time:0)
        }
    }
}

struct testSheet_Previews:PreviewProvider{
    static var previews: some View {
    testSheet()
    }
}

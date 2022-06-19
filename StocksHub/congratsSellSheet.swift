//
//  congratsSellSheet.swift
//  StocksHub
//
//  Created by Param Thakker on 4/29/22.
//

import Foundation
import SwiftUI
import SheetKit


struct CongratsSellSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var shares: Int
    @State var ticker: String
    @Binding var refreshDetailPage:Bool
    var body: some View {
        VStack {
            Spacer()
            Text("Congratulations!").font(.system(size: 40)).foregroundColor(Color.white).bold()
            Text("\n")
            if (shares>1){
                    Text("You have successfully sold \(shares) shares of \(ticker)!").font(.system(size: 20)).foregroundColor(Color.white).bold().multilineTextAlignment(.center)
            }
            else{
             
                    Text("You have successfully sold \(shares) share of \(ticker)!").font(.system(size: 20)).foregroundColor(Color.white).bold().multilineTextAlignment(.center)
                
            }
            Divider().opacity(0)
               Spacer()
            Button(action: {
                refreshDetailPage=false
                SheetKit().dismissAllSheets(animated:false)
                        }) {
                        Text("Done")
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color.green)
                            .background(Color.white)
                            .cornerRadius(90)
                    }
           }
           .background(Color.green)
          
    }
}

//struct sellSheet: View {
//    @State private var showingSheet = false
//
//    var body: some View {
//        Button("Show Sheet") {
//            showingSheet.toggle()
//        }
//        .sheet(isPresented: $showingSheet) {
//            CongratsSellSheet(shares: 2, ticker: "TSLA")
//        }
//    }
//}

//struct sellSheet_Previews:PreviewProvider{
//    static var previews: some View {
//    Sheet()
//    }
//}


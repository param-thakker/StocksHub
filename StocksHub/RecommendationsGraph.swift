//
//  RecommendationsGraph.swift
//  StocksHub
//
//  Created by Param Thakker on 4/21/22.
//

import Foundation
import SwiftUI
import Highcharts
import UIKit

//Reference: https://www.highcharts.com/demo/ios/column-stacked-percent
struct RecommendationsView:View{

    @StateObject var recModel=RecommendationsModel()
    @State var ticker:String

    var body: some View{
        if (recModel.isFetchingData){
            
            ProgressView().onAppear{
                recModel.fetch(stockName: ticker)
            }
        }
        else{
            Recommendations(strongBuy: recModel.strongBuyData, buy: recModel.buyData, hold: recModel.holdData, sell: recModel.sellData, strongSell: recModel.strongSellData,period:recModel.periodData)
        }
    }
}


struct Recommendations: UIViewRepresentable {
    @State var strongBuy:[Int]
    @State var buy:[Int]
    @State var hold:[Int]
    @State var sell:[Int]
    @State var strongSell:[Int]
    @State var period:[String]
    func makeUIView(context: Context) -> HIChartView {

     
        let chartView = HIChartView()
           let options = HIOptions()
            let chart = HIChart()
            chart.height = 500
            chart.width=420
            chart.type = "column"
            options.chart = chart
            let title = HITitle()
            title.text = "Recommendation Trends"
            options.title = title

            let xAxis = HIXAxis()
            xAxis.categories = period
            options.xAxis = [xAxis]

        //let options = HIOptions()
     //
     //            let title = HITitle()
     //            title.text = "Solar Employment Growth by Sector, 2010-2016"
     //            options.title = title
            let yAxis = HIYAxis()
            yAxis.min = 0
            yAxis.title = HITitle()
        
        
            yAxis.title.text = "#Analysis"
            yAxis.stackLabels = HIStackLabels()
        //            installation.name = "Installation"
        //            installation.data = [43934, 52503, 57177, 69658, 97031, 119931, 137133, 154175]
            
        
        yAxis.stackLabels.enabled = true
            yAxis.stackLabels.style = HICSSObject()
        //            let installation = HISeries()
        //            installation.name = "Installation"
        //            installation.data = [43934, 52503, 57177, 69658, 97031, 119931, 137133, 154175]
        
        
            yAxis.stackLabels.style.fontWeight = "bold"
            yAxis.stackLabels.style.color = "gray"
            options.yAxis = [yAxis]
        //            let installation = HISeries()
        //            installation.name = "Installation"
        //            installation.data = [43934, 52503, 57177, 69658, 97031, 119931, 137133, 154175]
            let legend = HILegend()
            legend.align = "right"
            legend.width="100%"
        //installation.name = "Installation"
       //            installation.data = [43934, 52503, 57177, 69658, 97031, 119931, 137133, 154175]
            legend.verticalAlign = "bottom"
            legend.floating = false
            legend.backgroundColor = HIColor(name: "white")
            legend.borderColor = HIColor(hexValue: "CCC")
        
//        tooltip.headerFormat = "<b>{point.x}</b><br/>"
//        tooltip.pointFormat = "{series.name}: {point.y}<br/>Total: {point.stackTotal}"
        
        
            legend.borderWidth = 1
            legend.shadow = HICSSObject()
            legend.shadow.opacity = 0
            options.legend = legend
        //yAxis.labels.formatter = HIFunction(jsFunction: "function () { return this.value + '°'; }")
            let tooltip = HITooltip()
            tooltip.headerFormat = "<b>{point.x}</b><br/>"
            tooltip.pointFormat = "{series.name}: {point.y}<br/>Total: {point.stackTotal}"
            options.tooltip = tooltip

            let plotOptions = HIPlotOptions()
            plotOptions.series = HISeries()
            plotOptions.series.stacking = "normal"
            let dataLabels = HIDataLabels()
            dataLabels.enabled = true
            plotOptions.series.dataLabels = [dataLabels]
            options.plotOptions = plotOptions
        
        //struct Recommendations_Previews: PreviewProvider {
        //
        //    static var previews: some View {
        //
        //        RecommendationsView()
        //
        //    }
        //}
            let StrongBuy = HIColumn()
            StrongBuy.name = "Strong Buy"
            StrongBuy.color=HIColor(name: "rgb(23,111,55)")
            StrongBuy.data=strongBuy
        //yAxis.labels.formatter = HIFunction(jsFunction: "function () { return this.value + '°'; }")
            let Buy = HIColumn()
            Buy.name = "Buy"
            Buy.color=HIColor(name:"rgb(29,185,84)")
            Buy.data = buy
        
            let Hold = HIColumn()
            Hold.name = "Hold"
            Hold.color=HIColor(name:"rgb(185,139,29)")
        //struct Recommendations_Previews: PreviewProvider {
        //
        //    static var previews: some View {
        //
        //        RecommendationsView()
        //
        //    }
        //}
        
        //struct Recommendations_Previews: PreviewProvider {
        //
        //    static var previews: some View {
        //
        //        RecommendationsView()
        //
        //    }
        //}
        
            Hold.data = hold
            let Sell = HIColumn()
            Sell.name = "Buy"
            Sell.color=HIColor(name:"rgb(244,91,91)")
            Sell.data = sell
            let StrongSell = HIColumn()
            StrongSell.name = "Strong Sell"
        //struct Recommendations_Previews: PreviewProvider {
        //
        //    static var previews: some View {
        //
        //        RecommendationsView()
        //
        //    }
        //}
//        let joe = HIColumn()
//            joe.name = "Joe"
//            joe.data = [3, 4, 4, 2, 5]
//
//            options.series = [john, jane, joe]
//
        
            StrongSell.color=HIColor(name:"rgb(129,49,49)")
            StrongSell.data = strongSell
        
            options.series = [StrongBuy, Buy, Hold,Sell,StrongSell]
       

        

            chartView.options = options
           return chartView

    }
    func updateUIView(_ uiView: HIChartView, context: Context)  {

    }
}




//struct Recommendations_Previews: PreviewProvider {
//   
//    static var previews: some View {
//        
//        RecommendationsView()
//
//    }
//}


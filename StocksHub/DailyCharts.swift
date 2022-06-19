//
//  DailyCharts.swift
//  StocksHub
//
//  Created by Param Thakker on 4/21/22.
//

import Foundation
import SwiftUI
import Highcharts
import UIKit



// Reference: https://www.highcharts.com/demo/ios/spline-plot-bands

struct DailyView:View{

    @StateObject var dailyModel=DailyChartsModel()
    @StateObject var lpModel=LatestPriceModel()
    @State var ticker:String
    @State var change:Double
    @State var time:Double
    var body: some View{
        if (dailyModel.isFetchingData){
            
            ProgressView().onAppear{
                dailyModel.fetch(stockName: ticker, time: time)
                //lpModel.fetch(stockName: ticker)
            }
        }
        else{
            DailyChart(closing: dailyModel.closingData, time: dailyModel.timeData,ticker:ticker,change:change).frame(width: 375, height: 380)

        }
       
    }

}

struct DailyChart: UIViewRepresentable {
    @State var closing:[Double]
    @State var time:[Double]
    @State var ticker:String
    @State var change:Double
    
    func makeUIView(context: Context) -> HIChartView {
        
//        let chartView = HIChartView()
//            //chartView.plugins = ["series-label"]
//
//            let options = HIOptions()
//
//            let title = HITitle()
//            title.text = "Solar Employment Growth by Sector, 2010-2016"
//            options.title = title
//
//            let subtitle = HISubtitle()
//            subtitle.text = "Source: thesolarfoundation.com"
//            options.subtitle = subtitle
//
//
////        let chart = HIChart()
////                 chart.height = 300
////                 chart.type = "spline"
////
////        options.chart=chart
//            let yAxis = HIYAxis()
//            yAxis.title = HITitle()
//            yAxis.title.text = "Number of Employees"
//            options.yAxis = [yAxis]
//
//            let xAxis = HIXAxis()
//            xAxis.accessibility = HIAccessibility()
//            xAxis.accessibility.rangeDescription = "Range: 2010 to 2017"
//            options.xAxis = [xAxis]
//
//            let legend = HILegend()
//            legend.layout = "vertical"
//            legend.align = "right"
//            legend.verticalAlign = "middle"
//            options.legend = legend
//
//            let plotOptions = HIPlotOptions()
//            plotOptions.series = HISeries()
//            plotOptions.series.label = HILabel()
//            plotOptions.series.label.connectorAllowed = false
//            plotOptions.series.pointStart = 2010
//            options.plotOptions = plotOptions
//
//            let installation = HISeries()
//            installation.name = "Installation"
//            installation.data = [43934, 52503, 57177, 69658, 97031, 119931, 137133, 154175]
//
//            let manufacturing = HISeries()
//            manufacturing.name = "Manufacturing"
//            manufacturing.data = [24916, 24064, 29742, 29851, 32490, 30282, 38121, 40434]
//
//            let salesDistribution = HISeries()
//            salesDistribution.name = "Sales & Distribution"
//            salesDistribution.data = [11744, 17722, 16005, 19771, 20185, 24377, 32147, 39387]
//
//            let projectDevelopment = HISeries()
//            projectDevelopment.name = "Project Development"
//            projectDevelopment.data = [NSNull(), NSNull(), 7988, 12169, 15112, 22452, 34400, 34227]
//
//            let other = HISeries()
//            other.name = "Other"
//            other.data = [12908, 5948, 8105, 11248, 8989, 11816, 18274, 18111]
//
//            options.series = [installation, manufacturing, salesDistribution, projectDevelopment, other]
//
//            let responsive = HIResponsive()
//            let rules = HIRules()
//            rules.condition = HICondition()
//            rules.condition.maxWidth = 500
//            rules.chartOptions = [
//              "legend": [
//                 "layout": "horizontal",
//                 "align": "center",
//                 "verticalAlign": "bottom"
//              ]
//            ]
//            responsive.rules = [rules]
//            options.responsive = responsive
//
//            chartView.options = options
//        return chartView
        
        
        
        
        var timeFormattedData:[String]=[]
        for index in 0 ..< time.count {
            timeFormattedData.append(String(time[index]))
        }
        let chartView = HIChartView()
          let options = HIOptions()
          let chart = HIChart()
         chart.height = 300
          chart.type = "spline"
          chart.scrollablePlotArea = HIScrollablePlotArea()
          chart.scrollablePlotArea.minWidth = 200
          chart.scrollablePlotArea.scrollPositionX = 1
          options.chart = chart

        
        
        
        //
        //
        //        let tt = HITooltip()
        //        tt.shared = true
        //        options.tooltip = tt
        //        let po = HIPlotOptions()
        //        po.spline = HISpline()
        //        po.spline.marker = HIMarker()
        //        po.spline.marker.radius = 4
        //        po.spline.marker.lineColor = "#666666"
        //        po.spline.marker.lineWidth = 1
        //        options.plotOptions = po
        
        
        
        
          let title = HITitle()
          title.text = "\(ticker) Hourly Price Variation"
          title.align = "center"
          options.title = title



//
//
//
//        let tt = HITooltip()
//        tt.shared = true
//        options.tooltip = tt
//        let po = HIPlotOptions()
//        po.spline = HISpline()
//        po.spline.marker = HIMarker()
//        po.spline.marker.radius = 4
//        po.spline.marker.lineColor = "#666666"
//        po.spline.marker.lineWidth = 1
//        options.plotOptions = po








          let xAxis = HIXAxis()
          //xAxis.type = "datetime"
        xAxis.type="datetime"

          xAxis.labels = HILabels()
          xAxis.labels.overflow = "justify"
        //xAxis.categories=timeFormattedData

        //xAxis.min=1651369070


        xAxis.max=1651670000000//1651668000000//1651664000000//1651664000000//1651671200000//1651418100000
        
//          xAxis.categories=["06:00","08:00","10:00","12:00"]//timeFormattedData
          options.xAxis = [xAxis]
        //          xAxis.categories=["06:00","08:00","10:00","12:00"]//timeFormattedData

        
          let yAxis = HIYAxis()
          yAxis.opposite=true
        
        //          xAxis.categories=["06:00","08:00","10:00","12:00"]//timeFormattedData
          yAxis.minorGridLineWidth = 0
        
          yAxis.gridLineWidth = 1
        yAxis.title=HITitle()
        yAxis.title.text=""

          options.yAxis = [yAxis]

        
        
          let tooltip = HITooltip()
          tooltip.valuePrefix = "$"
        //plotOptions.spline.pointInterval = 10800000
//        data=[160.53,160.925,160.7789,160.53,160.66,160.515,160.8699,161.35,161.45,16]
          options.tooltip = tooltip

          let plotOptions = HIPlotOptions()
          plotOptions.spline = HISpline()
        plotOptions.spline.name=ticker//"AAPL"
          plotOptions.spline.lineWidth = 4

        if (change>0){
        plotOptions.spline.color=HIColor(name: "rgba(0, 177, 106, 255)")
        }
        
        //plotOptions.spline.marker.name="AAPL"
          //plotOptions.spline.pointInterval = 10800000
//        data=[160.53,160.925,160.7789,160.53,160.66,160.515,160.8699,161.35,161.45,16]
//        //        let
        else{
            plotOptions.spline.color=HIColor(name: "rgb(255,0,0)")
        }
          plotOptions.spline.states = HIStates()
          plotOptions.spline.states.hover = HIHover()
          plotOptions.spline.states.hover.lineWidth = 5
          plotOptions.spline.marker = HIMarker()
          plotOptions.spline.marker.enabled = false
        plotOptions.spline.pointInterval = 360000 // one hour

        plotOptions.spline.pointStart = 1651644000000 //1651651200000//1651378000000

        //plotOptions.spline.marker.name="AAPL"
          //plotOptions.spline.pointInterval = 10800000

          options.plotOptions = plotOptions

          let priceData = HISpline()
//        let data=[160.53,160.925,160.7789,160.53,160.66,160.515,160.8699,161.35,161.45,161.2583,161.6215,161.53,161.37,161.73,161.913,162.12]
//        let data=[159.531,159.6557,159.569,159.5362,159.7,159.965,159.895,160.53,160.925,160.7789,160.53,160.66,160.515,160.8699,161.35,161.45,161.2583,161.6215,161.53,161.37,161.73,161.913,162.02,161.85,161.87,161.9355,162.17,161.88,162.34]
          priceData.data = closing

         priceData.showInLegend=false
         options.series = [priceData]



        chartView.options = options
        return chartView

    }
    func updateUIView(_ uiView: HIChartView, context: Context) {}

}


struct DailyChart_Previews: PreviewProvider {
   
    static var previews: some View {
        
        DailyChart(closing: [], time: [], ticker: "as", change: 3.2)

    }
}


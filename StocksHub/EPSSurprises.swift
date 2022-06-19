//
//  EPSSurprises.swift
//  StocksHub
//
//  Created by Param Thakker on 4/21/22.
//

import Foundation
import SwiftUI
import Highcharts


//Reference: https://www.highcharts.com/demo/ios/line-labels
struct EPSView:View{

    @StateObject var epsModel=EPSModel()
    @State var ticker:String

    var body: some View{
        if (epsModel.isFetchingData){
            
            ProgressView().onAppear{
                print("eps fetching data")
                
                epsModel.fetch(stockName: ticker)
            }
        }
        else{
            
            EPS(actual: epsModel.actualData, estimate: epsModel.estimateData, surprise: epsModel.surpriseData, period: epsModel.periodData,combinedData:epsModel.combinedXData)
                .onAppear{
                    print(epsModel.isFetchingData)
                    print(epsModel.actualData)
                }

        }
        
       
   


        
    }
}

struct EPS: UIViewRepresentable {
    @State var actual:[Double]
    @State var estimate:[Double]
    @State var surprise:[Double]
    @State var period:[String]
    @State var combinedData:[String]
  
    func makeUIView(context: Context) -> HIChartView {
        let chartView = HIChartView()
          chartView.plugins = ["series-label"]

          let options = HIOptions()

          let chart = HIChart()
          chart.type = "spline"
          chart.height=400
          options.chart = chart
//        let joe = HIColumn()
//            joe.name = "Joe"
//            joe.data = [3, 4, 4, 2, 5]
//
//            options.series = [john, jane, joe]
          let title = HITitle()
          title.text = "Historical EPS Surprises"
          options.title = title

        
        
          let xAxis = HIXAxis()
          //xAxis.cateories = period
        
        
        xAxis.labels=HILabels()
        xAxis.categories=combinedData
        //        let joe = HIColumn()
        //            joe.name = "Joe"
        //            joe.data = [3, 4, 4, 2, 5]
        //
        //            options.series = [john, jane, joe]
        xAxis.labels.rotation = -52
        
          options.xAxis = [xAxis]
          let yAxis = HIYAxis()
          yAxis.title = HITitle()
          yAxis.title.text = "Quarterly EPS"
          yAxis.labels = HILabels()
          //yAxis.labels.formatter = HIFunction(jsFunction: "function () { return this.value + '°'; }")
          options.yAxis = [yAxis]

          let tooltip = HITooltip()
          tooltip.shared = true
          options.tooltip = tooltip
          let plotOptions = HIPlotOptions()
          plotOptions.spline = HISpline()
          plotOptions.spline.marker = HIMarker()
        
        
        
        //        let joe = HIColumn()
        //            joe.name = "Joe"
        //            joe.data = [3, 4, 4, 2, 5]
        //
        //            options.series = [john, jane, joe]
          plotOptions.spline.marker.radius = 4
          plotOptions.spline.marker.lineColor = "#666666"
          plotOptions.spline.marker.lineWidth = 1
          options.plotOptions = plotOptions

        
        
        //        let joe = HIColumn()
        //            joe.name = "Joe"
        //            joe.data = [3, 4, 4, 2, 5]
        //
        //            options.series = [john, jane, joe]
          let actualSpline = HISpline()
          actualSpline.name = "Actual"
          actualSpline.marker = HIMarker()
          actualSpline.marker.symbol = "circle"

          let actualData = HIData()
          actualData.y = 26.5
          actualData.marker = HIMarker()

          actualSpline.data = actual
          let estimateSpline = HISpline()
          estimateSpline.name = "Estimate"
        
        
        
//        let title = HITitle()
//        title.text = "Monthly Average Temperature"
//        options.title = title
//
//        let subtitle = HISubtitle()
//        subtitle.text = "Source: WorldClimate.com"
//        options.subtitle = subtitle
//
//        let xAxis = HIXAxis()
//        xAxis.categories = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//        options.xAxis = [xAxis]
//
//        let yAxis = HIYAxis()
//        yAxis.title = HITitle()
//        yAxis.title.text = "Temperature (°C)"
//        options.yAxis = [yAxis]
//
//        let plotOptions = HIPlotOptions()
//        plotOptions.line = HILine()
//
//        let dataLabels = HIDataLabels()
//        dataLabels.enabled = true
//        plotOptions.line.dataLabels = [dataLabels]
//
//        plotOptions.line.enableMouseTracking = false
//        options.plotOptions = plotOptions
//
//        let tokyo = HILine()
//        tokyo.name = "Tokyo"
//        tokyo.data = [7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
//
//        let london = HILine()
//        london.name = "London"
        
        
        
        
        
        
        
        
        
        
        
      
        
          estimateSpline.marker = HIMarker()
          estimateSpline.marker.symbol = "diamond"
          let estimateData = HIData()
          estimateData.y = 3.9
          estimateData.marker = HIMarker()
          estimateSpline.data = estimate
          options.series = [actualSpline, estimateSpline]
          chartView.options = options

        return chartView

    }
    func updateUIView(_ uiView: HIChartView, context: Context) {}

}

//
//struct EPS_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        EPS(actual: [], estimate: [], surprise: [], period: [])
//
//    }
//}


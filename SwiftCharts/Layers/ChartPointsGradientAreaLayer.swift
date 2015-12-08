//
//  ChartPointsGradientAreaLayer.swift
//  SwiftCharts
//
//  Created by creisterer on 08/12/15.
//  Copyright © 2015 ivanschuetz. All rights reserved.
//

import UIKit

public class ChartPointsGradientAreaLayer<T: ChartPoint>: ChartPointsLayer<T> {

    private let areaColors: [UIColor]
    private let gradientStart: CGPoint
    private let gradientEnd: CGPoint
    private let animDuration: Float
    private let animDelay: Float
    private let addContainerPoints: Bool

    public init(xAxis: ChartAxisLayer, yAxis: ChartAxisLayer, innerFrame: CGRect, chartPoints: [T], areaColors: [UIColor], gradientStart: CGPoint, gradientEnd: CGPoint, animDuration: Float, animDelay: Float, addContainerPoints: Bool) {
        self.areaColors = areaColors
        self.gradientStart = gradientStart
        self.gradientEnd = gradientEnd
        self.animDuration = animDuration
        self.animDelay = animDelay
        self.addContainerPoints = addContainerPoints

        super.init(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints)
    }

    override func display(chart chart: Chart) {
        var points = self.chartPointScreenLocs

        let origin = self.innerFrame.origin
        let xLength = self.innerFrame.width

        let bottomY = origin.y + self.innerFrame.height

        if self.addContainerPoints {
            points.append(CGPointMake(origin.x + xLength, bottomY))
            points.append(CGPointMake(origin.x, bottomY))
        }

        let areaView = ChartAreasView(points: points, frame: chart.bounds, colors: areaColors, gradientStart: gradientStart, gradientEnd: gradientEnd, animDuration: animDuration, animDelay: animDelay)
        
        chart.addSubview(areaView)
    }
}

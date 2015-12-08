//
//  ChartLineModel.swift
//  swift_charts
//
//  Created by ischuetz on 11/04/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit

public struct ChartLineModel<T: ChartPoint> {

    let chartPoints: [T]
    let lineColor: UIColor
    let lineWidth: CGFloat
    let animDuration: Float
    let animDelay: Float
    let gradient: GradientModel?

    public init(chartPoints: [T], lineColor: UIColor, lineWidth: CGFloat = 1, animDuration: Float, animDelay: Float, gradient: GradientModel? = nil) {
        self.chartPoints = chartPoints
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        self.animDuration = animDuration
        self.animDelay = animDelay
        self.gradient = gradient
    }

    var chartPointsCount: Int {
        return self.chartPoints.count
    }

}

public struct GradientModel {
    let colors: [UIColor]
    let start: CGPoint
    let end: CGPoint

    public init(colors: [UIColor], start: CGPoint, end: CGPoint) {
        self.colors = colors
        self.start = start
        self.end = end
    }
}

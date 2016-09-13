//
//  ChartLinesView.swift
//  swift_charts
//
//  Created by ischuetz on 11/04/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit

public protocol ChartLinesViewPathGenerator {
    func generatePath(points points: [CGPoint], lineWidth: CGFloat) -> UIBezierPath
}

public class ChartLinesView: UIView {

    private let lineColor: UIColor
    private let lineWidth: CGFloat
    private let animDuration: Float
    private let animDelay: Float

    private let lineColors: [UIColor]?
    private let gradientStart: CGPoint?
    private let gradientEnd: CGPoint?

    init(path: UIBezierPath, frame: CGRect, lineColor: UIColor, lineWidth: CGFloat, animDuration: Float, animDelay: Float) {

        self.lineColor = lineColor
        self.lineWidth = lineWidth
        self.animDuration = animDuration
        self.animDelay = animDelay

        self.lineColors = nil
        self.gradientStart = nil
        self.gradientEnd = nil

        super.init(frame: frame)

        self.backgroundColor = UIColor.clearColor()
        self.show(path: path)
    }

    init(path: UIBezierPath, frame: CGRect, lineColors: [UIColor], gradientStart: CGPoint, gradientEnd: CGPoint, lineWidth: CGFloat, animDuration: Float, animDelay: Float) {

        self.lineColor = lineColors.first ?? UIColor.blackColor()
        self.lineWidth = lineWidth
        self.animDuration = animDuration
        self.animDelay = animDelay

        self.lineColors = lineColors
        self.gradientStart = gradientStart
        self.gradientEnd = gradientEnd

        super.init(frame: frame)

        self.backgroundColor = UIColor.clearColor()
        self.show(path: path)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createLineMask(frame frame: CGRect) -> CALayer {
        let lineMaskLayer = CAShapeLayer()
        var maskRect = frame
        maskRect.origin.y = 0
        maskRect.size.height = frame.size.height
        let path = CGPathCreateWithRect(maskRect, nil)

        lineMaskLayer.path = path

        return lineMaskLayer
    }

    private func generateLayer(path path: UIBezierPath) -> CAShapeLayer {
        let lineLayer = CAShapeLayer()
        lineLayer.lineJoin = kCALineJoinRound
        lineLayer.fillColor   = nil
        lineLayer.lineWidth   = self.lineWidth

        lineLayer.path = path.CGPath;
        lineLayer.strokeColor = self.lineColor.CGColor;

        if self.animDuration > 0 {
            lineLayer.strokeEnd   = 0.0
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = CFTimeInterval(self.animDuration)
            pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pathAnimation.fromValue = NSNumber(float: 0)
            pathAnimation.toValue = NSNumber(float: 1)
            pathAnimation.autoreverses = false
            pathAnimation.removedOnCompletion = false
            pathAnimation.fillMode = kCAFillModeForwards

            pathAnimation.beginTime = CACurrentMediaTime() + CFTimeInterval(self.animDelay)
            lineLayer.addAnimation(pathAnimation, forKey: "strokeEndAnimation")

        } else {
            lineLayer.strokeEnd = 1
        }

        return lineLayer
    }

    private func generateGradient() -> CAGradientLayer? {
        guard let _lineColors = lineColors, _gradientStart = gradientStart, _gradientEnd = gradientEnd else {
            return nil
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = _gradientStart
        gradientLayer.endPoint = _gradientEnd
        gradientLayer.frame = CGRectMake(0, 0, layer.bounds.size.width, layer.bounds.size.height)
        let cgcolors = _lineColors.map { $0.CGColor }
        gradientLayer.colors = cgcolors
        return gradientLayer
    }

    private func show(path path: UIBezierPath) {
        let lineMask = self.createLineMask(frame: frame)
        self.layer.mask = lineMask
        let lineLayer = generateLayer(path: path)
        if let _gradient = generateGradient() {
            _gradient.mask = lineLayer
            layer.addSublayer(_gradient)
        } else {
            layer.addSublayer(lineLayer)
        }
    }
}

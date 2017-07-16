//
//  UIBezier+Arrow.swift
//  RxSignalVisualizer
//
//  Created by Rafal on 09/12/2016.
//  Copyright © 2016 PerformGroup. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath {

    class func getAxisAlignedArrowPoints(forLength: CGFloat, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> Array<CGPoint> {
        var points = Array<CGPoint>()
        let tailLength = forLength - headLength
        points.append(CGPoint(x: 0, y: tailWidth / 2))
        points.append(CGPoint(x: tailLength, y: tailWidth / 2))
        points.append(CGPoint(x: tailLength, y: headWidth / 2))
        points.append(CGPoint(x: forLength, y: 0))
        points.append(CGPoint(x: tailLength, y: -headWidth / 2))
        points.append(CGPoint(x: tailLength, y: -tailWidth / 2))
        points.append(CGPoint(x: 0, y: -tailWidth / 2))
        return points
    }

    class func transformForStartPoint(startPoint: CGPoint, endPoint: CGPoint, length: CGFloat) -> CGAffineTransform {
        let cosine: CGFloat = (endPoint.x - startPoint.x) / length
        let sine: CGFloat = (endPoint.y - startPoint.y) / length

        return CGAffineTransform(
                a: cosine,
                b: sine,
                c: -sine,
                d: cosine,
                tx: startPoint.x,
                ty: startPoint.y)
    }

    class func bezierPathWithArrowFromPoint(startPoint: CGPoint, endPoint: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> UIBezierPath {

        let xdiff: Float = Float(endPoint.x) - Float(startPoint.x)
        let ydiff: Float = Float(endPoint.y) - Float(startPoint.y)
        let length = hypotf(xdiff, ydiff)

        let points = getAxisAlignedArrowPoints(forLength: CGFloat(length), tailWidth: tailWidth, headWidth: headWidth, headLength: headLength)

        let transform = transformForStartPoint(
                startPoint: startPoint,
                endPoint: endPoint,
                length: CGFloat(length))

        let cgPath = CGMutablePath()
        cgPath.addLines(between: points, transform: transform)
        return UIBezierPath(cgPath: cgPath)
    }
}

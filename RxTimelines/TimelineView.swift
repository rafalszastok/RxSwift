//
//  TimelineView.swift
//  RxSignalVisualizer
//
//  Created by Rafal on 09/12/2016.
//  Copyright © 2016 PerformGroup. All rights reserved.
//

import Foundation
import UIKit

class TimelineView: UIView {
    private var circles: [TimelineCircleView] = []

    func addCircleAt(position: CGFloat, name: String, color: UIColor) {
        assert(position <= 100 && position >= 0, "invalid input value")
        let circle = TimelineCircleView.addCircle(toView: self,
                                                  atPosition: position,
                                                  name: name)
        circles.append(circle)
        circle.color = color
    }

    override func draw(_ rect: CGRect) {
        print("Drawing")
        UIColor.black.setStroke()
        let centerLeft = CGPoint(x: bounds.minX + 10, y: bounds.midY)
        let centerRight = CGPoint(x: bounds.maxX - 10, y: bounds.midY)
        let lineBezierPath = UIBezierPath.bezierPathWithArrowFromPoint(
                startPoint: centerLeft,
                endPoint: centerRight,
                tailWidth: 1,
                headWidth: 10,
                headLength: 10)
        lineBezierPath.stroke()
    }
}

class TimelineViewFactory {
    static func createLines(inView view: UIView, count: Int) -> [TimelineView] {
        var timeLinesView: [TimelineView] = []
        for _ in 0 ..< count {
            let timeLineView = addLine(toView: view)
            if let previousLine = timeLinesView.last {
                timeLineView.topAnchor.constraint(
                        equalTo: previousLine.bottomAnchor).isActive = true
            } else {
                timeLineView.topAnchor.constraint(
                        equalTo: view.topAnchor).isActive = true
            }
            timeLinesView.append(timeLineView)
        }
        return timeLinesView
    }

    private static func addLine(toView view: UIView, height: CGFloat = 50) -> TimelineView {
        let timeline = TimelineView()
        view.addSubview(timeline)
        timeline.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(
                equalTo: timeline.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(
                equalTo: timeline.trailingAnchor).isActive = true
        timeline.backgroundColor = .clear
        timeline.heightAnchor.constraint(equalToConstant: height).isActive = true
        return timeline
    }
}

//
//  TimelineCircleView.swift
//  RxSignalVisualizer
//
//  Created by Rafal on 09/12/2016.
//  Copyright © 2016 PerformGroup. All rights reserved.
//

import UIKit

class TimelineCircleView: UIView {
    var color: UIColor = UIColor.lightGray
    let label: UILabel
    
    required init() {
        label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        super.init(frame: CGRect.zero)
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(
            equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(
            equalTo: self.centerYAnchor).isActive = true
        label.widthAnchor.constraint(
            equalTo: self.widthAnchor,
            constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func addCircle(toView view: UIView,
                          atPosition position: CGFloat,
                          name: String) -> TimelineCircleView {
        let circle = TimelineCircleView()
        circle.label.text = name
        view.addSubview(circle)
        circle.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: circle,
                attribute: .leading,
                relatedBy: .equal,
                toItem: view,
                attribute: .trailing,
                multiplier: position / 100,
                constant: 0)
        view.addConstraint(constraint)
        view.centerYAnchor.constraint(
                equalTo: circle.centerYAnchor).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 30).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        circle.backgroundColor = .clear
        return circle
    }

    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        color.setFill()
        let path = UIBezierPath(ovalIn: bounds.insetBy(dx: 2, dy: 2))
        path.fill()
        path.lineWidth = 2
        path.stroke()
    }
}

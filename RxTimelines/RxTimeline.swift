//
//  RxTimeline.swift
//  RxSignalVisualizer
//
//  Created by Rafal on 10/12/2016.
//  Copyright © 2016 PerformGroup. All rights reserved.
//

import UIKit
import Foundation

import RxSwift
import RxCocoa

class RxBoard {
        var currentPosition: Int = 0
    var timelines: [RxTimeline] = []
}

protocol RxTimelineDelegate {
    var currentTime: Int { get }
    func tick()
}

class RxTimeline {
    var delegate: RxTimelineDelegate?
    let timelineView: TimelineView
    var eventVariable = Variable<String>("")

    var colorArray: [UIColor] = [.red, .green, .blue]
    let disposeBag = DisposeBag()
    
    init(timelineView: TimelineView, delegate: RxTimelineDelegate) {
        self.delegate = delegate
        self.timelineView = timelineView
        eventVariable
                .asObservable()
                .filter {
                    !$0.isEmpty
                }
                .subscribe(onNext: { (identifier) in
                    timelineView.addCircleAt(position: (CGFloat(delegate.currentTime)+1) * 10.0,
                            name: identifier,
                            color: self.colorArray[delegate.currentTime % self.colorArray.count])
                    delegate.tick()
                })
                .addDisposableTo(disposeBag)

    }
}

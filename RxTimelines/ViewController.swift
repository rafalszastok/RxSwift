//
//  ViewController.swift
//  RxSignalVisualizer
//
//  Created by Rafal on 09/12/2016.
//  Copyright © 2016 PerformGroup. All rights reserved.
//

import UIKit
import RxTest
import RxSwift
import RxCocoa

extension ViewController: RxTimelineDelegate {
    func tick() {
        currentTime += 10
    }
}

class ViewController: UIViewController {
    var currentTime: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timelineViews = TimelineViewFactory.createLines(inView: self.view, count: 3)
        
        let rxTimelines = timelineViews.map { RxTimeline(timelineView: $0, delegate: self) }
        zip(timelines: rxTimelines)
    }

    func zip(timelines: [RxTimeline]) {
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()

        _ = stringSubject
            .bindTo(timelines[0].eventVariable)
        _ = intSubject
            .map { "\($0)" }
            .bindTo(timelines[1].eventVariable)
        _ = Observable.zip(stringSubject, intSubject) { stringElement, intElement in
                    return "\(stringElement) \(intElement)"
                }
            .bindTo(timelines[2].eventVariable)

        stringSubject.onNext("🅰️")
        stringSubject.onNext("🅱️")

        intSubject.onNext(1)

        intSubject.onNext(2)

        stringSubject.onNext("🆎")
        intSubject.onNext(3)
    }
}

//
//  Board.swift
//  RxSignalVisualizer
//
//  Created by Rafal on 11/12/2016.
//  Copyright © 2016 PerformGroup. All rights reserved.
//

import UIKit

class Board: UIView {
    let boardView: UIView
    var currentTime: Int = 0
    let timelines: [TimelineView]
    
    init (boardView: UIView, count: Int) {
        self.boardView = boardView
        timelines = TimelineViewFactory.createLines(inView: boardView, count: count)
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

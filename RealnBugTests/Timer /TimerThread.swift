//
//  TimerThread.swift
//  RealnBugTests
//
//  Created by Krasa on 23/11/2018.
//  Copyright © 2018 Ronte. All rights reserved.
//

import Foundation

class TimerThread: Thread {
    let timer: Timer
    init(timer: Timer) {
        self.timer = timer
        super.init()
    }
    
    override func main() {
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        RunLoop.current.run()
    }
}

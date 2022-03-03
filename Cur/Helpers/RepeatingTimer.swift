//
//  RepeatingTimer.swift
//  Cur
//
//  Created by Alex Tyurin on 03.03.2022.
//

import Foundation

final class RepeatingTimer {
    let timeInterval: TimeInterval
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }

    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                self?.eventHandler?()
            }

        })
        return t
    }()

    var eventHandler: (() -> Void)?
    enum State {
        case suspended
        case resumed
    }
    private(set) var state: State = .suspended
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }

    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}

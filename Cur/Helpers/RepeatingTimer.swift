//
//  RepeatingTimer.swift
//  Cur
//
//  Created by Alex Tyurin on 03.03.2022.
//

import Foundation

final class RepeatingTimer {
    private let steps: Int
    private var activeStep: Int = 0
    private enum State {
        case suspended
        case resumed
    }
    private var state: State = .suspended

    var eventHandler: ((_ step: Int) -> Void)?

    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource()
        activeStep = steps
        timer.schedule(deadline: .now() + 1, repeating: 1)
        timer.setEventHandler(handler: { [weak self] in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.activeStep -= 1
                if self.activeStep < 0 {
                    self.activeStep = self.steps
                }
                self.eventHandler?(self.activeStep)
            }

        })
        return timer
    }()

    init(steps: Int) {
        self.steps = steps
    }

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        start()
        eventHandler = nil
    }

    var isActive: Bool {
        state == .resumed
    }

    func restartIfActive() {
        if isActive {
            stop()
            start()
        }
    }

    func start() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }

    func stop() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}

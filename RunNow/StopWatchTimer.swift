//
//  StopWatchTimer.swift
//  RunNow
//
//  Created by Foundation-010 on 19/06/25.
//

import Foundation
import Combine

class StopWatchTimer: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    private var timer: Timer?
    private var startDate: Date?
    private var lastElapsed: TimeInterval = 0
    
    func StartWatch() {
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard let start = self.startDate else { return }
            self.elapsedTime = self.lastElapsed + Date().timeIntervalSince(start)
        }
    }
    
    func StopWatch() {
        timer?.invalidate()
        timer = nil
        if let start = startDate {
            lastElapsed += Date().timeIntervalSince(start)
        }
        startDate = nil
    }
    
    func ResetTimer() {
        elapsedTime = 0
        startDate = nil
    }
    
    var minutes: Double {
        elapsedTime / 60
    }
    
    var formated: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

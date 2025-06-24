//
//  MotionTracker.swift
//  RunNow
//
//  Created by Foundation-010 on 19/06/25.
//

import Foundation
import CoreMotion
import Combine

//sdfafafa Dantul Kontol
//why use this ObservaleObject??? karna setiap data yang berubah maka akan langsung di update oleh UI
class MotionTracker: ObservableObject {
    private let pedometer = CMPedometer()
    private var timer: Timer?
    
    @Published var distance: Double = 0
    @Published var steps: Int = 0
    @Published var pace: Double = 0
    
    
    func startTracking() {
        guard CMPedometer.isStepCountingAvailable(),
              CMPedometer.isPaceAvailable(),
              CMPedometer.isDistanceAvailable() else {
            print("Pedometer features are not available on this device")
            return
        }

        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Pedometer Error: \(error.localizedDescription)")
                    return
                }
                guard let data = data else { return }
                self?.distance = data.distance?.doubleValue ?? 0
                self?.steps = data.numberOfSteps.intValue
                self?.pace = data.currentPace?.doubleValue ?? 0
            }
        }
    }

    
    
    func stopTracking() {
        pedometer.stopUpdates()
    }
    
    func estimateMET() -> Double {
        
        guard pace > 0 else { return 1.0}
        
        let speedMS = 1 / pace
        
        let speedKPH = speedMS * 3.6
        
        switch speedKPH {
        case 0..<7: return 3.5
        case 7..<9: return 8.3
        case 9..<11: return 9.8
        case 11..<13: return 11.0
        case 13..<15 :return 11.8
        default: return 12.8
        }
    }
    
    func estimateCaloriesBurned(weightKG: Double, minutes: Double) -> Double {
        return estimateMET() * weightKG * (minutes / 60)
    }

    
    
}

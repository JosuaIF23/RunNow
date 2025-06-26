//
//  RunningBurnTracker.swift
//  RunNow
//
//  Created by Foundation-010 on 19/06/25.
//

import SwiftUI

struct RunningBurnTrackerView: View {
    @StateObject var motion = MotionTracker()
    @StateObject var timer = StopWatchTimer()
    
    @State private var isRunnig = false
    @State  var userWeightKg : Double
    
    
    //this is adding
    @State private var finalCaloriesBurned: Double?
    @State private var runFinished = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            Text("Running Burn Tracker")
            .font(.largeTitle)
            .bold()
            
            Text(" Time: \(timer.formated)")
                .font(.title2)
            
            Text("Distance: \(motion.distance / 1000, specifier: "%.2f") km")
            
            Text("Steps: \(motion.steps)")
            Text("Pace: \(motion.pace, specifier: "%.2f") m/s")
            
            Text("MET: \(motion.estimateMET(), specifier: "%.1f")")
//            Text("Calories Burned: \(motion.estimateCaloriesBurned(weightKG: userWeightKg, minutes: timer.minutes), specifier: "%.0f") cal")

            
            
            if let calories = finalCaloriesBurned {
                Text("Calories Burned: \(calories, specifier: "%.0f") cal")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.red)
            }
            
            if !isRunnig {
                
                Button("Start") {
                    isRunnig = true
                    runFinished = false
                    finalCaloriesBurned = nil
                    motion.startTracking()
                    timer.StartWatch()
                    
                }
                .padding()
                .frame(width: 100)
                .background(Color.green)
                .foregroundColor(Color.white)
                .cornerRadius(12)
            } else {
                Button("Stop") {
                    isRunnig = false
                    motion.stopTracking()
                    timer.StopWatch()
                    runFinished = true
                    finalCaloriesBurned = motion.estimateCaloriesBurned(weightKG: userWeightKg, minutes: timer.minutes)
                }
                .padding()
                .frame(width: 100)
                .background(Color.red)
                .foregroundColor(Color.white)
                .cornerRadius(12)
            }
            Spacer()
            
        }
        .padding()
    }
}

#Preview {
   RunningBurnTrackerView(userWeightKg: 60)
}

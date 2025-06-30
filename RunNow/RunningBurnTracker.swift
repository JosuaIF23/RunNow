//
//  RunningBurnTrackerView.swift
//  RunNow
//
//  Created by Foundation-010 on 19/06/25.
//

import SwiftUI

struct RunningBurnTrackerView: View {
    @StateObject var motion = MotionTracker()
    @StateObject var timer = StopWatchTimer()

    @State private var isRunning = false
    let userWeightKg: Double
    
    @State private var finalCaloriesBurned: Double?
    @State private var runFinished = false
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Burn Calorie App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue) // Ganti dengan .shadedBlue jika didefinisikan
                .padding(.top, 30)

            VStack(spacing: 10) {
                HStack(spacing: 5) {
                    Image(systemName: "clock.fill")
                    Text("Time")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.cyan) // Ganti dengan .lightBlue jika didefinisikan
                }

                Text(timer.formated)
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.bottom)

                HStack {
                    VStack {
                        Text("Distance")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.cyan) // Ganti dengan .lightBlue jika didefinisikan
                        Text("\(motion.distance / 1000, specifier: "%.2f") km")
                            .fontWeight(.medium)
                    }

                    Spacer()

                    VStack {
                        Text("Calories")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.cyan) // Ganti dengan .lightBlue jika didefinisikan
                        if let calories = finalCaloriesBurned {
                            Text("\(calories, specifier: "%.0f") cal")
                                .fontWeight(.medium)
                        } else {
                            Text("\(motion.estimateCaloriesBurned(weightKG: userWeightKg, minutes: timer.minutes), specifier: "%.0f") cal")
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                        }
                    }

                    Spacer()

                    VStack {
                        Text("Pace")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.cyan) // Ganti dengan .lightBlue jika didefinisikan
                        Text("\(motion.pace, specifier: "%.2f") m/s")
                            .fontWeight(.medium)
                    }
                }
                .padding()
                .frame(width: 350, height: 90)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                .padding(.horizontal)
            }

            Spacer()

            Button(action: {
                if !isRunning {
                    isRunning = true
                    runFinished = false
                    finalCaloriesBurned = nil
                    motion.startTracking()
                    timer.startWatch()
                } else {
                    isRunning = false
                    motion.stopTracking()
                    timer.stopWatch()
                    runFinished = true
                    finalCaloriesBurned = motion.estimateCaloriesBurned(weightKG: userWeightKg, minutes: timer.minutes)
                }
            }) {
                Text(isRunning ? "Stop" : "Start")
                    .frame(width: 100, height: 60)
                    .foregroundColor(.white)
                    .background(isRunning ? .red : .green)
                    .clipShape(Circle())
                    .padding(.bottom, 50)
            }
            .font(.headline)
            .fontWeight(.semibold)
        }
        .padding()
    }
}

#Preview {
    RunningBurnTrackerView(userWeightKg: 60)
}



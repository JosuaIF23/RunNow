//
//  RunningBurnTrackerView.swift
//  RunNow
//
//  Created by Foundation-010 on 19/06/25.
//

import SwiftUI
import SwiftData

struct RunningBurnTrackerView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var motion = MotionTracker()
    @StateObject var timer = StopWatchTimer()
    @State private var isRunning = false
    let dailyData: DailyDataModel?
    @State private var goToDetail = false
    @State private var newDailyData: DailyDataModel?
    
    @State private var finalCaloriesBurned: Double?
    @State private var runFinished = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Burn Calorie App")
                .font(.title)
                .bold()
                .foregroundColor(.blue)
                .padding(.vertical, 50)
            
            Text("\(timer.formated)")
                .font(.title)
                .bold()
                .padding(.vertical, 50)
            
            if !isRunning {
                Button("Start") {
                    isRunning = true
                    runFinished = false
                    finalCaloriesBurned = nil
                    motion.startTracking()
                    timer.startWatch()
                }
                .padding()
                .frame(width: 100)
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Circle())
            } else {
                Button("Stop") {
                    isRunning = false
                    motion.stopTracking()
                    timer.stopWatch()
                    runFinished = true
                    finalCaloriesBurned = motion.estimateCaloriesBurned(weightKG: currentWeight, minutes: timer.minutes)

                    saveRunData()

                    // Tambahkan sedikit delay agar data tersimpan dulu
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        goToDetail = true
                    }
                }


                
                .padding()
                .frame(width: 100)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Circle())
            }
            
            HStack(spacing: 16) {
                VStack {
                    Text("Distance")
                        .foregroundColor(.cyan)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("\(motion.distance / 1000, specifier: "%.2f") km")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.systemGray6))
                )
                
                VStack {
                    Text("Calories")
                        .foregroundColor(.cyan)
                        .font(.title3)
                        .fontWeight(.semibold)
                    if let calories = finalCaloriesBurned {
                        Text("\(calories, specifier: "%.0f") cal")
                            .fontWeight(.medium)
                    } else {
                        Text("\(motion.estimateCaloriesBurned(weightKG: currentWeight, minutes: timer.minutes), specifier: "%.0f") cal")
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.systemGray6))
                )
            }
            .padding(.horizontal)
            
            HStack(spacing: 16) {
                VStack {
                    Text("Pace")
                        .foregroundColor(.cyan)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("\(motion.pace, specifier: "%.2f") m/s")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.systemGray6))
                )
                
                VStack {
                    Text("MET")
                        .foregroundColor(.cyan)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("\(motion.estimateMET(), specifier: "%.1f")")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.systemGray6))
                )
            }
            .padding(.horizontal)
            
            if let calories = finalCaloriesBurned, runFinished {
                Text("Calories Burned: \(calories, specifier: "%.0f") cal")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.red)
                    .padding(.top, 20)
            }
            
            Spacer()
            
            if let data = newDailyData {
                NavigationLink(
                    destination: DetailView(dailyData: data),
                    isActive: $goToDetail
                ) {
                    EmptyView()
                }
                .opacity(0)
            }

        }
        .padding()
    }
    
    
    
    private var currentWeight: Double {
        guard let weightDiff = dailyData?.weightDifference else { return 60.0 } // Default to 60 kg if no data
        let idealWeight = 22.0 * (1.7 * 1.7) // Example: Assume height 1.7m, BMI 22
        return idealWeight + weightDiff
    }
    
    private func saveRunData() {
        guard let dailyData = dailyData, let caloriesBurned = finalCaloriesBurned else { return }
        
        if let currentCalories = dailyData.caloriesToBurn {
            dailyData.caloriesToBurn = max(0, currentCalories - Int(caloriesBurned))
        }
        
        let weightLoss = caloriesBurned / 7700.0
        let newWeight = currentWeight - weightLoss
        
        let runData = RunDataModel(
            distance: motion.distance,
            duration: timer.minutes,
            caloriesBurned: Int(caloriesBurned),
            updatedWeight: newWeight,
            runDate: Date(),
            dailyData: dailyData
        )
        
        dailyData.runData = runData
        modelContext.insert(runData)

        do {
            try modelContext.save()
            newDailyData = dailyData
        } catch {
            print("Failed to save run data: \(error.localizedDescription)")
        }
    }

}

#Preview {
    RunningBurnTrackerView(dailyData: DailyDataModel(
        id: UUID(),
        date: Date(),
        bmi: 27.0,
        category: "Overweight",
        weightDifference: 5.0,
        caloriesToBurn: 38500,
        name: "Placidia"
    ))
    .modelContainer(for: [DailyDataModel.self, RunDataModel.self])
}

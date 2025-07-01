import SwiftUI

struct RunningBurnTrackerView: View {
    @StateObject var motion = MotionTracker()
    @StateObject var timer = StopWatchTimer()
    
    @State private var isRunning = false
    let userWeightKg: Double
    
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
                    finalCaloriesBurned = motion.estimateCaloriesBurned(weightKG: userWeightKg, minutes: timer.minutes)
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
                        Text("\(motion.estimateCaloriesBurned(weightKG: userWeightKg, minutes: timer.minutes), specifier: "%.0f") cal")
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
        }
        .padding()
    }
}

#Preview {
    RunningBurnTrackerView(userWeightKg: 60)
}

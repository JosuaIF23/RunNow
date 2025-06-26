//
//  RunningBurnTracker.swift
//  RunNow
//
//  Created by Foundation-010 on 19/06/25.
//

import SwiftUI

struct RunningBurnTrackerView: View {
    var motion = MotionTracker()
    var timer = StopWatchTimer()

    var isRunnig = false
    var userWeightKg : Double
    
    
    //this is adding
    var finalCaloriesBurned: Double?
    var runFinished = false
    
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            
            Text("\(timer.formated)")
                .font(.title)
                .bold()
                .padding(.vertical, 120 )
            
            if !isRunnig {
                
                Button("Start") {
                    isRunnig = true
                    runFinished = false
                    finalCaloriesBurned = nil
                    motion.startTracking()
                    timer.StartWatch()
        
                    
                }
                .foregroundColor(.kuning)
                .padding()
                .frame(width: 80)
                .background(Color(UIColor.systemGray6))
                .foregroundColor(Color.white)
                .cornerRadius(360)
                
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
                .cornerRadius(360)
            }
            
            HStack(spacing: 40){
                
                VStack {
                    Text("Distance") .foregroundColor(.cyn)
                    Text("\(motion.distance / 1000, specifier: "%.2f") km")
    
                }
                
                
                VStack{
                    Text("Steps") .foregroundColor(.ning)
                    Text("\(motion.steps)")
                        
                }
                
                VStack{
                    Text("Pace") .foregroundColor(.rah)
                    Text("\(motion.pace, specifier: "%.2f") m/s")
                }
                
                VStack{
                    Text("MET") .foregroundColor(.ru)
                    Text(" \(motion.estimateMET(), specifier: "%.1f")")
                    
                }
                
            }
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.systemGray6))
            )
            //            Text("Calories Burned: \(motion.estimateCaloriesBurned(weightKG: userWeightKg, minutes: timer.minutes), specifier: "%.0f") cal")
            
            
            
            if let calories = finalCaloriesBurned {
                Text("Calories Burned: \(calories, specifier: "%.0f") cal")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.red)
            }
            
            Image("maps")
                .resizable()
                .frame(width: 300, height: 200)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.systemGray6))
                )
                .shadow(radius: 2)
                

            
   
            
        }
        Spacer()
        
   
    }
}


#Preview {
   RunningBurnTrackerView(userWeightKg: 60)
}
//@StateObject var motion = MotionTracker()
//@StateObject var timer = StopWatchTimer()

//@State private var isRunnig = false
//@State  var userWeightKg : Double


//this is adding
//@State private var finalCaloriesBurned: Double?
//@State private var runFinished = false

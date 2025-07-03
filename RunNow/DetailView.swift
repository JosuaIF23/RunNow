//
//  DetailView.swift
//  RunNow
//
//  Created by Foundation-005 on 25/06/25.
//

import SwiftUI

struct DetailView: View {
    let dailyData: DailyDataModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
     
        VStack(spacing: 16) {
            
            Spacer()
            Text("Detail for \(dailyData.name)")
                .font(.title)
                .bold()
            
            if let bmi = dailyData.bmi {
                Text("BMI: \(String(format: "%.2f", bmi))")
                    .font(.headline)
            }
            
            if let category = dailyData.category {
                Text("Category: \(category)")
                    .font(.headline)
            }
            
            if let weightDiff = dailyData.weightDifference {
                let currentWeight = calculateCurrentWeight(weightDifference: weightDiff)
                Text("Current Weight: \(String(format: "%.1f", currentWeight)) kg")
                    .font(.headline)
            }
            
            if let calories = dailyData.caloriesToBurn {
                Text("Calories to Burn: \(calories) cal")
                    .font(.headline)
            }
            
            if let runData = dailyData.runData {
                Text("Updated Weight After Run: \(String(format: "%.1f", runData.updatedWeight)) kg")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            Text("Date: \(DateFormatter.localizedString(from: dailyData.date, dateStyle: .medium, timeStyle: .short))")
                .font(.subheadline)
            
            Spacer()
            
            NavigationLink(destination: ParentView(name: dailyData.name)) {
                Text("OK")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 30)


            .buttonStyle(.borderedProminent)
            .padding(.top, 30)
            Spacer()
        }
        .padding()
        .navigationTitle("Detail")
    }
    
    private func calculateCurrentWeight(weightDifference: Double) -> Double {
        let idealWeight = 22.0 * (1.7 * 1.7) // Example: Assume height 1.7m, BMI 22
        return idealWeight + weightDifference
    }
}

#Preview {
    DetailView(dailyData: DailyDataModel(
        id: UUID(),
        date: Date(),
        bmi: 27.0,
        category: "Overweight",
        weightDifference: 5.0,
        caloriesToBurn: 38500,
        name: "Placidia",
        runData: RunDataModel(
            distance: 5000,
            duration: 30,
            caloriesBurned: 300,
            updatedWeight: 74.7,
            runDate: Date()
        )
    ))
    .modelContainer(for: [DailyDataModel.self, RunDataModel.self])
}

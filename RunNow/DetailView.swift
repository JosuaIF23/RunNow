//
//  DetailView.swift
//  RunNow
//
//  Created by Foundation-005 on 25/06/25.
//

import SwiftUI

struct DetailView: View {
    let dailyData: DailyDataModel
    
    var body: some View {
        VStack(spacing: 16) {
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
                Text("Weight Difference: \(String(format: "%.1f", weightDiff)) kg")
                    .font(.headline)
            }
            
            if let calories = dailyData.caloriesToBurn {
                Text("Calories to Burn: \(calories) cal")
                    .font(.headline)
            }
            
            Text("Date: \(DateFormatter.localizedString(from: dailyData.date, dateStyle: .medium, timeStyle: .short))")
                .font(.subheadline)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Detail")
    }
}

//#Preview {
//    DetailView(dailyData: DailyDataModel(date: Date(), name: "Yizzrel", bmi: 23.1, category: "Normal Ideal weight", weightDifference: 0.0, caloriesToBurn: 70))
//        .modelContainer(for: DailyDataModel.self)
//}

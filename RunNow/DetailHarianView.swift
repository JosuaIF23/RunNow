//
//  DetailHarianView.swift
//  RunNow
//
//  Created by Nathaniel on 03/07/25.
//

import SwiftUI

struct DetailHarianView: View {
    let dailyData: DailyDataModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Detail Harian")
                .font(.title)
                .bold()
                .padding(.top, 20)
            
            if let bmi = dailyData.bmi {
                Text("BMI: \(String(format: "%.2f", bmi))")
                    .font(.headline)
            }
            
            if let category = dailyData.category {
                Text("Kategori: \(category)")
                    .font(.headline)
            }
            
            if let weightDiff = dailyData.weightDifference {
                let currentWeight = calculateCurrentWeight(weightDifference: weightDiff)
                Text("Berat Saat Ini: \(String(format: "%.1f", currentWeight)) kg")
                    .font(.headline)
            }
            
            if let calories = dailyData.caloriesToBurn {
                Text("Kalori yang harus dibakar: \(calories) cal")
                    .font(.headline)
            }
            
            if let runData = dailyData.runData {
                VStack(spacing: 8) {
                    Text("Data Lari:")
                        .font(.headline)
                        .padding(.top, 12)
                    
                    Text("Jarak: \(runData.distance / 1000, specifier: "%.2f") km")
                    Text("Durasi: \(runData.duration) menit")
                    Text("Kalori Terbakar: \(runData.caloriesBurned) cal")
                    Text("Berat Setelah Lari: \(String(format: "%.1f", runData.updatedWeight)) kg")
                }
                .foregroundColor(.blue)
            }
            
            Text("Tanggal: \(dateToString(dailyData.date))")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 12)
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Text("Back")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .padding()
    }
    
    private func calculateCurrentWeight(weightDifference: Double) -> Double {
        let idealWeight = 22.0 * (1.7 * 1.7) // Misalnya tinggi 1.7m, BMI ideal 22
        return idealWeight + weightDifference
    }
    
    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEEE, dd MMMM yyyy HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    DetailHarianView(dailyData: DailyDataModel(
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

//
//  BMIResultPopupView.swift
//  RunNow
//
//  Created by Foundation-010 on 18/06/25.
//

import SwiftUI
import SwiftData

struct BMIResultPopup: View {
    let name: String
    let bmi: Double
    let category: String
    let onClose: () -> Void
    @Binding var goToRunning: Bool
    let weightDifference: Double
    let caloriesToBurn: Int
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Hi, \(name)!")
                .font(.body)
                .fontWeight(.bold)
            
            Text("Your BMI is \(String(format: "%.2f", bmi)). Your body category is \(category). \(weightDifferenceText())")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            if caloriesToBurn > 0 {
                Text("To reach your ideal weight, you need to burn approximately \(caloriesToBurn) calories.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            } else {
                Text("You're at your ideal weight, no calories to burn!")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
            
            Divider()
                .padding(.vertical, 8)
            
            HStack(spacing: 16) {
                Button("Back") {
                    // Discard data and allow recalculation
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .font(.headline)
                .fontWeight(.semibold)
                .tint(.shadedWhite)
                .foregroundStyle(.white)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.shadedWhite)
                )
                
                Spacer()
                
                Button("OK") {
                    saveData()
                    goToRunning = true // ⬅️ ini penting!
                    onClose()
                }

                .buttonStyle(.borderedProminent)
                .font(.headline)
                .fontWeight(.semibold)
                .tint(.shadedWhite)
                .foregroundStyle(.white)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.shadedWhite)
                )
            }
            .foregroundStyle(.darkHue)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 1)
        )
        .padding(.horizontal, 16)
    }
    
    func weightDifferenceText() -> String {
        switch category {
        case "Underweight":
            return String(format: "You're %.1f kg below your ideal body weight.", abs(weightDifference))
        case "Normal Ideal weight":
            return "You're at your ideal weight."
        case "Overweight", "Obese":
            return String(format: "You're %.1f kg above your ideal body weight.", weightDifference)
        default:
            return ""
        }
    }
    
    private func saveData() {
        let dailyData = DailyDataModel(
            date: Date(),
            bmi: bmi,
            category: category,
            weightDifference: weightDifference,
            caloriesToBurn: caloriesToBurn,
            name: name
        )
        modelContext.insert(dailyData)
        do {
            try modelContext.save()
            print("Data saved successfully to SwiftData.")
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DailyDataModel.self, RunDataModel.self, configurations: config)
    
    @State var goToRunning = false
    
    return BMIResultPopup(
        name: "Jane",
        bmi: 27.0,
        category: "Overweight",
        onClose: {
            print("Preview: onClose triggered")
        },
        goToRunning: $goToRunning,
        weightDifference: 5.0,
        caloriesToBurn: 38500 // Non-zero to show buttons
    )
    .modelContainer(container)
    .padding()
    .background(Color.gray.opacity(0.1))
}

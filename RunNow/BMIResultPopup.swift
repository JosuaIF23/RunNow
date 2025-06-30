//
//  BMIResultPopup.swift
//  RunForBetter
//
//  Created by Foundation-010 on 17/06/25.
//

import SwiftUI

struct BMIResultPopup: View {
    let name: String
    let bmi: Double
    let category: String
    let onClose: () -> Void
    @Binding var goToRunning: Bool
    let weightDifference: Double
    let caloriesToBurn: Int
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
                    .font(.largeTitle)
                
                Divider()
                    .padding(.vertical, 8)
                
                HStack(spacing: 16) {
                    Button("Back") {
                        onClose()
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .tint(.shadedWhite)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.shadedWhite)
                    )
                    
                    Button("Let's Start Running") {
                        goToRunning = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.shadedOrange)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.shadedOrange)
                    )
                }
            }
                .foregroundStyle(.darkHue)
                .padding(.horizontal, 20)
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
    }
}

#Preview {
BMIResultPopup(name: "User", bmi: 23.1, category: "Normal Ideal weight",
               onClose: {}, goToRunning: .constant(false), weightDifference: 0.0, caloriesToBurn: 70)
}


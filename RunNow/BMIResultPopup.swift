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
    var onClose: () -> Void
    
    @Binding var goToRunning: Bool
    
    let weightDifference: Double
    let caloriesToBurn: Int
    
    var body: some View {
        VStack (spacing: 16) {
            
            Text("\(name)✌️")
                .font(.title)
            
            
            Text("Your BMI")
                .font(.headline)
            
            Text(String(format: "%.2f", bmi))
                .font(.largeTitle)
                .bold()
            
            Text("Your Body Category is:")
                .font(.headline)
            
            Text(category)
                .font(.headline)
                .foregroundColor(.black)
            
    
            Text(weightDifferenceText())
                .font(.headline)
                .foregroundColor(.black)
            
            if caloriesToBurn > 0 {
                Text("To reach Your Ideal Weight, you need to burn approximately:")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                
                Text("\(caloriesToBurn) calories")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.red)
            }
            
            HStack {
                Button("Back") {
                    onClose()
                }
            
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Let's Start Running") {
                    goToRunning = true
                }
                .padding()
                .background(Color.green)
                .foregroundColor(Color.white)
                .cornerRadius(8)
                
 
                
                
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
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


#Preview {
    BMIResultPopup(name: "Yizzrel", bmi: 23.1, category: "Normal Ideal weight",
                 
                   onClose: {},  goToRunning: .constant(false), weightDifference: 0.0, caloriesToBurn: 70)
}


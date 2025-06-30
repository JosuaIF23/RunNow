//
//  BMIInputView.swift
//  RunForBetter
//
//  Created by Foundation-010 on 16/06/25.
//

import SwiftUI

struct BMIInputView: View {
    let name: String
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var bmi: Double?
    @State private var category: String = ""
    @State private var showPopup: Bool = false
    @State private var weightDiff: Double = 0
    @State private var showBMICategories: Bool = false
    @State private var showInfoSheet: Bool = false
    @State private var calories: Int = 0
    @State private var goToRunning: Bool = false
    @State private var weightAsDouble: Double = 0
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    Text("Burn Calori App")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.darkHue)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 30) {
                        Text("Hello \(name), welcome to B-Cal App! This app helps you calculate your ideal weight. Press the 'Calculate BMI' button to see your results.")
                            .foregroundColor(.darkHue)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .lineSpacing(5)
                            .font(.body)
                        
                        VStack(spacing: 20) {
                            VStack(spacing: 16) {
                                HStack {
                                    Label {
                                        Text("Weight")
                                            .font(.body)
                                            .fontWeight(.medium)
                                    } icon: {
                                        Image(systemName: "scalemass")
                                            .foregroundColor(.orangeHue)
                                    }
                                    .font(.title2)
                                    .foregroundColor(.darkHue)
                                    
                                    Spacer()
                                    
                                    TextField("Kg", text: $weight) {
                                    }
                                    .textFieldStyle(.plain)
                                    .keyboardType(.decimalPad)
                                    .font(.body)
                                    .frame(width: 120)
                                }
                                
                                HStack {
                                    Label {
                                        Text("Height")
                                            .font(.body)
                                            .fontWeight(.medium)
                                    } icon: {
                                        Image(systemName: "ruler")
                                            .foregroundColor(.orangeHue)
                                    }
                                    .font(.title2)
                                    .foregroundColor(.darkHue)
                                    
                                    Spacer()
                                    
                                    TextField("Cm", text: $height) {
                                    }
                                    .textFieldStyle(.plain)
                                    .keyboardType(.decimalPad)
                                    .font(.body)
                                    .frame(width: 120)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 24)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 1)
                            }
                            .padding(.horizontal, 16)
                            
                            // Calculate button
                            Button(action: {
                                calculateBMI()
                            }) {
                                Text("Calculate BMI")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(.white)
                                    .background {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.orangeHue)
                                    }
                            }
                            .padding(.horizontal, 16)
                            .shadow(color: Color.orangeHue.opacity(0.3), radius: 4, x: 0, y: 2)
                            
                            // BMI Categories Button
                            Button(action: {
                                withAnimation {
                                    showBMICategories.toggle()
                                }
                            }) {
                                Text(showBMICategories ? "Hide BMI Categories" : "Show BMI Categories (WHO)")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(.white)
                                    .background {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.shadedWhite)
                                    }
                            }
                            .padding(.horizontal, 16)
                            .shadow(color: Color.shadedWhite.opacity(0.3), radius: 4, x: 0, y: 2)
                            
                            // BMI Categories Content
                            if showBMICategories {
                                VStack(spacing: 20) {
                                    VStack {
                                        HStack {
                                            Text("Category")
                                            Spacer()
                                            Text("BMI Range")
                                        }
                                        
                                        Divider()
                                        
                                        row("Underweight", "< 18.5", highlight: category == "Underweight")
                                        row("Normal (Ideal)", "18.5 – 24.9", highlight: category == "Normal Ideal weight")
                                        row("Overweight", "25 – 29.9", highlight: category == "Overweight")
                                        row("Obesity Class I", "30 – 34.9", highlight: category == "Obese" && (bmi ?? 0) < 35)
                                        row("Obesity Class II", "35 – 39.9", highlight: category == "Obese" && (bmi ?? 0) < 40 && (bmi ?? 0) >= 35)
                                        row("Obesity Class III", "≥ 40", highlight: category == "Obese" && (bmi ?? 0) >= 40)
                                    }
                                    .padding()
                                    .background {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.white)
                                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 1)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            
                            Spacer()
                        }
                    }
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showInfoSheet = true
                            }) {
                                Image(systemName: "info.circle")
                            }
                        }
                    }
                    .sheet(isPresented: $showInfoSheet) {
                        BMISheetInfoView()
                    }
                }
                
                // Popup as full-screen overlay
                if showPopup, let result = bmi {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showPopup = false
                            }
                        }
                    
                    BMIResultPopup(
                        name: name,
                        bmi: result,
                        category: category,
                        onClose: {
                            withAnimation {
                                showPopup = false
                            }
                        },
                        goToRunning: $goToRunning,
                        weightDifference: weightDiff,
                        caloriesToBurn: calories
                        )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // <--- ADDED TO CENTER POPUP
                    .overlay {
                        NavigationLink("", destination: RunningBurnTrackerView(userWeightKg: weightAsDouble), isActive: $goToRunning)
                            .opacity(0)
                    }
                    .onChange(of: goToRunning) { _ in
                        showPopup = false
                    }
                }
            }
        }
    }
    
    func caloriesConvertWeight(from weightDiff: Double) -> Int {
        Int(weightDiff * 7700)
    }
    
    func row(_ label: String, _ value: String, highlight: Bool = false) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
        }
    }
    
    func idealSubtraction(weight: Double, heightCm: Double) -> Double {
        let heightM = heightCm / 100
        let idealBMI = 22.0
        let idealWeight = idealBMI * (heightM * heightM)
        return weight - idealWeight
    }
    
    func calculateBMI() {
        guard let w = Double(weight), let h = Double(height), h > 0 else {
            bmi = nil
            category = "Invalid input"
            return
        }
        
        let heightInMeter = h / 100
        let result = w / (heightInMeter * heightInMeter)
        bmi = result
        
        switch result {
        case ..<18.5:
            category = "Underweight"
        case 18.5..<24.9:
            category = "Normal Ideal weight"
        case 24.9..<29.9:
            category = "Overweight"
        default:
            category = "Obese"
        }
        
        weightDiff = idealSubtraction(weight: w, heightCm: h)
        calories = weightDiff > 0 ? caloriesConvertWeight(from: weightDiff) : 0
        weightAsDouble = w
        showPopup = true
        }
    }


#Preview {
    BMIInputView(name: "user")
}

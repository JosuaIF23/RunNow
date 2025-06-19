//
//  BMIInputView.swift
//  RunForBetter
//
//  Created by Foundation-010 on 16/06/25.
//

import SwiftUI

struct BMIInputView: View {
    let name: String
//    @AppStorage("userName") private var name: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var bmi: Double?
    @State private var category: String = ""
    @State private var showPopup: Bool = false
    @State private var weightDiff: Double = 0
    @State private var showBMICategories: Bool = false
    @State private var showInfoSheet: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var calories: Int = 0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                Text("BMI Calculator")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.3))

                ZStack {
                    Color.gray.opacity(0.05).ignoresSafeArea()

                    VStack(spacing: 20) {
                        Spacer().frame(height: 20)

                        Text("Hai \(name), welcome to the app")
                            .font(.title2)
                            .bold()
                            .padding(.top, 20)

                        TextField("Enter weight (kg)", text: $weight)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            .frame(maxWidth: 300)
                            .font(.system(size: 30))
                            .background(.ultraThinMaterial)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                        TextField("Enter height (cm)", text: $height)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            .frame(maxWidth: 300)
                            .font(.system(size: 30))
                            .background(.ultraThinMaterial)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                        Button(action: {
                            calculateBMI()
                        }) {
                            Text("Calculate BMI")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding()
                                .frame(width: 180)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(radius: 5)
                        }

                        DisclosureGroup(isExpanded: $showBMICategories) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Category").bold()
                                    Spacer()
                                    Text("BMI Range").bold()
                                }
                                .padding(.bottom, 2)

                                Divider()

                                row("Underweight", "< 18.5", highlight: category == "Underweight")
                                row("Normal (Ideal)", "18.5 – 24.9", highlight: category == "Normal Ideal weight")
                                row("Overweight", "25 – 29.9", highlight: category == "Overweight")
                                row("Obesity Class I", "30 – 34.9", highlight: category == "Obese" && (bmi ?? 0) < 35)
                                row("Obesity Class II", "35 – 39.9", highlight: category == "Obese" && (bmi ?? 0) < 40 && (bmi ?? 0) >= 35)
                                row("Obesity Class III", "≥ 40", highlight: category == "Obese" && (bmi ?? 0) >= 40)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                        } label: {
                            Text("Show BMI Categories (WHO)")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)
                                .cornerRadius(12)
                        }
                        .accentColor(.black)
                        .padding(.horizontal)

                        Spacer()
                    }
                }
            }
            .navigationTitle("BMI Input")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showInfoSheet = true
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $showInfoSheet) {
                BMISheetInfoView()
            }

            if showPopup, let result = bmi {
                Color.black.opacity(0.4).ignoresSafeArea()

                BMIResultPopup(
                    name: name,
                    bmi: result,
                    category: category,
                    onClose: { withAnimation { showPopup = false } },
                    weightDifference: weightDiff,
                    caloriesToBurn: calories
                )
                .transition(.scale)
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
        .padding(.vertical, 4)
        .padding(.horizontal)
        .background(highlight ? Color.orange.opacity(0.15) : Color.clear)
        .cornerRadius(8)
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
        showPopup = true
        showBMICategories = true
    }
}

#Preview {
    BMIInputView(name: "yizzrell")
}

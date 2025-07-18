//
//  BMISheetInfoView.swift
//  RunNow
//
//  Created by Foundation-010 on 18/06/25.
//



import SwiftUI

struct BMISheetInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        Text("""
                        Body Mass Index (BMI) is a simple calculation using a person's height and weight. The formula is:

                        BMI = weight (kg) / [height (m)]²

                        It helps categorize people into:
                        - Underweight
                        - Normal (Ideal)
                        - Overweight
                        - Obese

                        BMI is a screening tool but not a diagnostic of body fat or health.
                        """)
                            .font(.callout)
                            .padding()
                    }
                    .navigationTitle(Text("BMI Information"))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Close") {
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }

#Preview {
    BMISheetInfoView()
}

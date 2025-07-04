import SwiftUI

struct DetailHarianView: View {
    let dailyData: DailyDataModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("📊 Daily Details")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 24)

                sectionCard {
                    VStack(alignment: .leading, spacing: 12) {
                        if let bmi = dailyData.bmi {
                            infoRow(icon: "scalemass", title: "BMI", value: String(format: "%.2f", bmi))
                        }

                        if let category = dailyData.category {
                            infoRow(icon: "person.fill.questionmark", title: "Category", value: category)
                        }

                        if let weightDiff = dailyData.weightDifference {
                            let currentWeight = calculateCurrentWeight(weightDifference: weightDiff)
                            infoRow(icon: "figure.stand", title: "Current Weight", value: "\(String(format: "%.1f", currentWeight)) kg")
                        }

                        if let calories = dailyData.caloriesToBurn {
                            infoRow(icon: "flame.fill", title: "Calories to Burn", value: "\(calories) cal")
                        }
                    }
                }

                if let runData = dailyData.runData {
                    sectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🏃‍♀️ Running Data")
                                .font(.headline)
                                .padding(.bottom, 4)

                            infoRow(icon: "location.fill", title: "Distance", value: "\(String(format: "%.2f", runData.distance / 1000)) km")
                            infoRow(icon: "clock.fill", title: "Duration", value: "\(runData.duration) minutes")
                            infoRow(icon: "flame", title: "Calories Burned", value: "\(runData.caloriesBurned) cal")
                            infoRow(icon: "scalemass", title: "Weight After Run", value: "\(String(format: "%.1f", runData.updatedWeight)) kg")
                        }
                    }
                }

                Text("📅 Date: \(dateToString(dailyData.date))")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Button(action: {
                    dismiss()
                }) {
                    Label("Back", systemImage: "arrow.backward.circle.fill")
                        .font(.headline)
                        .frame(width: 100)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color("belakang"))
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            .padding(.horizontal)
        }
    }

    // MARK: - UI Components

    private func infoRow(icon: String, title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text("\(title):")
                .bold()
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }

    private func sectionCard<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        VStack {
            content()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color("burem")))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - Logic

    private func calculateCurrentWeight(weightDifference: Double) -> Double {
        let idealWeight = 22.0 * (1.7 * 1.7)
        return idealWeight + weightDifference
    }

    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
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

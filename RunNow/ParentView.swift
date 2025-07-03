//
//  ParentView.swift
//  RunNow
//
//  Created by Foundation-005 on 19/06/25.
//

import SwiftUI
import SwiftData

struct ParentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DailyDataModel.date, order: .reverse) private var allData: [DailyDataModel]

    let name: String
    @State private var goToTracker = false
    @State private var latestProgress: DailyDataModel?

    var body: some View {
        let dailyData = allData.filter { $0.name == name }
        let validData = dailyData.filter { $0.bmi != nil && $0.category != nil }

        NavigationStack {
            VStack(spacing: 10) {
                Text("Burn Calorie App")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 30) {
                    Text("Hai, \(name)!")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)

                    if validData.isEmpty {
                        Text("Tidak ada data tersedia")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach(validData, id: \.id) { data in
                                    VStack(alignment: .leading, spacing: 9) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 9) {
                                                Text(dateToString(data.date))
                                                    .font(.title3)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.black)

                                                Text(statusText(for: data))
                                                    .font(.body)
                                                    .foregroundColor(.black)
                                            }
                                            Spacer()
                                            NavigationLink(destination: DetailHarianView(dailyData: data)) {
                                                Text("Detail Harian")
                                                    .font(.headline)
                                                    .bold()
                                                    .padding(.vertical, 8)
                                                    .padding(.horizontal, 16)
                                                    .background(Color.blue)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(8)
                                            }
                                        }
                                    }
                                    .padding()
                                    .frame(width: 350)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
                            .padding(.top)
                        }
                    }

                    Spacer()

                    // Tombol Lanjut Progres (Selalu buat baru)
                    Button(action: {
                        let now = Date()

                        if let template = dailyData
                            .filter { $0.bmi != nil && $0.category != nil }
                            .sorted(by: { $0.date < $1.date })
                            .last {

                            let newData = DailyDataModel(
                                date: now,
                                bmi: template.bmi,
                                category: template.category,
                                weightDifference: template.weightDifference,
                                caloriesToBurn: template.caloriesToBurn,
                                name: name
                            )

                            modelContext.insert(newData)
                            try? modelContext.save()
                            latestProgress = newData
                        }
                    }) {
                        Text("Lanjut Progres!")
                            .font(.headline)
                            .bold()
                            .padding()
                            .frame(width: 350)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }

                    // Navigasi ke Tracker
                    NavigationLink(
                        destination: latestProgress.map { RunningBurnTrackerView(dailyData: $0) },
                        isActive: $goToTracker
                    ) {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .padding(.horizontal)
                .onChange(of: latestProgress) { _ in
                    goToTracker = latestProgress != nil
                }
            }
            .background(Color.white)
            .padding(.top)
        }
    }

    // MARK: - Helpers

    private func statusText(for data: DailyDataModel) -> String {
        let baseText = getStatusText(data: data)
        if let weightDifference = data.weightDifference {
            return "\(baseText). Your ideal is \(Int(weightDifference)) kg"
        }
        return baseText
    }

    private func getStatusText(data: DailyDataModel) -> String {
        switch data.category {
        case "Normal Ideal weight": return "You are ideal weight"
        case "Underweight": return "You are underweight"
        case "Overweight": return "You are overweight"
        case "Obese": return "You are obese"
        default: return "No data"
        }
    }

    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEEE, dd MMMM yyyy HH:mm" // BONUS: Include time
        return formatter.string(from: date)
    }
}



#Preview {
    ParentView(name: "Daniel")
        .modelContainer(for: [DailyDataModel.self, RunDataModel.self])
}

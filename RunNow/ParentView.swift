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
    @Query(sort: \DailyDataModel.date, order: .reverse) private var dailyData: [DailyDataModel]
    let name: String

    @State private var goToTracker = false
    @State private var latestProgress: DailyDataModel?

    var body: some View {
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

                    if dailyData.isEmpty {
                        Text("Tidak ada data tersedia")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach(dailyData, id: \.id) { data in
                                    VStack(alignment: .leading, spacing: 9) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 9) {
                                                Text(dateToString(data.date))
                                                    .font(.title2)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.black)

                                                Text(statusText(for: data))
                                                    .font(.body)
                                                    .foregroundColor(.black)
                                            }
                                            Spacer()
                                            NavigationLink(destination: RunningBurnTrackerView(dailyData: data)) {
                                                Text("Run")
                                                    .font(.headline)
                                                    .bold()
                                                    .padding(.vertical, 8)
                                                    .padding(.horizontal, 16)
                                                    .background(Color.blue)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(8)
                                            }
                                        }

                                        NavigationLink(destination: DetailView(dailyData: data)) {
                                            EmptyView()
                                        }
                                        .frame(width: 0, height: 0)
                                        .opacity(0)
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

                    Button(action: {
                        let newData = DailyDataModel(
                            date: Date(),
                            bmi: dailyData.first?.bmi,
                            category: dailyData.first?.category,
                            weightDifference: dailyData.first?.weightDifference,
                            caloriesToBurn: dailyData.first?.caloriesToBurn,
                            name: name
                        )
                        modelContext.insert(newData)
                        try? modelContext.save()
                        latestProgress = newData
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

                    // ⬇️ NavigationLink tersembunyi, trigger via state
                    if let data = latestProgress {
                        NavigationLink(
                            destination: RunningBurnTrackerView(dailyData: data),
                            isActive: $goToTracker
                        ) {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.white)
            .padding(.top)
            .onChange(of: latestProgress) { newValue in
                if newValue != nil {
                    goToTracker = true
                }
            }
            .onAppear {
                print("Loaded data count: \(dailyData.count)")
            }
        }
    }

    private func statusText(for data: DailyDataModel) -> String {
        let baseText = getStatusText(data: data)
        if let weightDifference = data.weightDifference {
            return "\(baseText). Your ideal is \(Int(weightDifference)) kg"
        }
        return baseText
    }

    private func getStatusText(data: DailyDataModel) -> String {
        guard let category = data.category else { return "No data" }
        switch category {
        case "Normal Ideal weight": return "You are ideal weight"
        case "Underweight": return "You are underweight"
        case "Overweight": return "You are overweight"
        case "Obese": return "You are obese"
        default: return "No category"
        }
    }

    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    ParentView(name: "Placidia")
        .modelContainer(for: [DailyDataModel.self, RunDataModel.self])
}


#Preview {
    ParentView(name: "Placidia")
        .modelContainer(for: [DailyDataModel.self, RunDataModel.self])
}

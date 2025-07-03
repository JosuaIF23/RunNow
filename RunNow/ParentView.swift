import SwiftUI
import SwiftData

struct ParentView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \DailyDataModel.date, order: .reverse)
    private var allData: [DailyDataModel]

    let name: String
    @State private var filteredData: [DailyDataModel] = []
    @State private var goToTracker = false
    @State private var latestProgress: DailyDataModel?
    @State private var isCreating = false

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

                    if filteredData.isEmpty {
                        Text("Tidak ada data tersedia")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach(filteredData, id: \.id) { data in
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

                    Button(action: createNewProgress) {
                        HStack {
                            if isCreating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text("Lanjut Progres!")
                                .font(.headline)
                                .bold()
                        }
                        .padding()
                        .frame(width: 350)
                        .background(isCreating ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                    .disabled(isCreating)

                    NavigationLink(
                        destination: latestProgress.map {
                            RunningBurnTrackerView(dailyData: $0)
                                .onDisappear {
                                    latestProgress = nil
                                    goToTracker = false
                                    isCreating = false
                                }
                        },
                        isActive: $goToTracker
                    ) {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .padding(.horizontal)
            }
            .background(Color.white)
            .padding(.top)
        }
        .onAppear {
            filterData()
        }
        .onChange(of: allData) { _ in
            filterData()
        }
    }

    // MARK: - Filtering & Creation

    private func filterData() {
        let filtered = allData.filter { $0.name == name && $0.bmi != nil && $0.category != nil }

        // Hindari duplikat berdasarkan menit (buang milidetik)
        let grouped = Dictionary(grouping: filtered) { data in
            Calendar.current.date(bySetting: .second, value: 0, of: data.date) ?? data.date
        }

        filteredData = grouped.values.map { $0.first! }.sorted(by: { $0.date > $1.date })
    }

    private func createNewProgress() {
        guard !isCreating else { return }
        isCreating = true

        let now = Date()

        // Cegah spam dalam 10 detik terakhir
        if let last = filteredData.first, now.timeIntervalSince(last.date) < 10 {
            print("⛔️ Sudah ada data dalam 10 detik terakhir")
            isCreating = false
            return
        }

        guard let template = filteredData.last else {
            print("⚠️ Tidak ada template valid untuk user \(name)")
            isCreating = false
            return
        }

        let newData = DailyDataModel(
            date: now,
            bmi: template.bmi,
            category: template.category,
            weightDifference: template.weightDifference,
            caloriesToBurn: template.caloriesToBurn,
            name: name
        )

        modelContext.insert(newData)

        do {
            try modelContext.save()
            print("✅ Inserted new data for \(name) at \(now)")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                latestProgress = newData
                goToTracker = true
            }

        } catch {
            print("❌ Gagal simpan data baru: \(error)")
            isCreating = false
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
        formatter.dateFormat = "EEEE, dd MMMM yyyy HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    ParentView(name: "Daniel")
        .modelContainer(for: [DailyDataModel.self, RunDataModel.self])
}

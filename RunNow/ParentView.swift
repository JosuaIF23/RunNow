import SwiftUI
import SwiftData

struct ParentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DailyDataModel.date, order: .reverse) private var dailyData: [DailyDataModel]
    let name: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Text("Burn Calorie App")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, 20) // Tambahkan padding lebih besar untuk jarak dari atas
                
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
                        VStack(spacing: 20) {
                            ForEach(dailyData, id: \.id) { data in
                                NavigationLink(destination: DetailView(dailyData: data)) {
                                    VStack(alignment: .leading, spacing: 9) {
                                        Text(dateToString(data.date))
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        
                                        Text(statusText(for: data))
                                            .font(.body)
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                    .frame(width: 350)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if !dailyData.isEmpty {
                        NavigationLink(destination: RunningBurnTrackerView(userWeightKg: dailyData.first?.weightDifference ?? 60.0)) {
                            Text("Lanjut Progres!")
                                .font(.headline)
                                .bold()
                                .padding()
                                .frame(width: 350)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.white)
            // Menghapus .ignoresSafeArea() untuk menghormati safe area
            .padding(.top) // Padding tambahan untuk memastikan konten tidak terlalu dekat dengan tepi atas
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
        case "Normal Ideal weight":
            return "You are ideal weight"
        case "Underweight":
            return "You are underweight"
        case "Overweight":
            return "You are overweight"
        case "Obese":
            return "You are obese"
        default:
            return "No category"
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

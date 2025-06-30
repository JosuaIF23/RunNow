import SwiftUI
import SwiftData

struct ParentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DailyDataModel.date, order: .reverse) private var dailyData: [DailyDataModel]
    let name: String

    var body: some View {
        NavigationView {
            VStack {
                Text("Burn Calorie App")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black) // Mengganti putih dengan hitam untuk kontras netral
                    .padding(.top)
                
                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.3)) // Abu-abu netral untuk divider
                
                VStack(alignment: .leading) {
                    Text("Hai, \(name)!")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black) // Hitam untuk teks utama
                        .padding(.top, 10)
                    
                    List {
                        ForEach(dailyData) { data in
                            VStack {
                                // Item pertama: Tanggal dengan warna netral
                                Text(dateToString(data.date))
                                    .font(.subheadline)
                                    .foregroundColor(.gray) // Abu-abu untuk teks sekunder
                                
                                // Item kedua: Status teks sebagai NavigationLink
                                NavigationLink(destination: DetailView(dailyData: data)) {
                                    Text(getStatusText(data: data))
                                        .font(.headline)
                                        .foregroundColor(.black) // Hitam untuk teks utama
                                }
                                
                                Spacer()
                                
                                // Tombol "Run" dengan warna netral
                                if data.bmi != nil {
                                    NavigationLink(destination: RunningBurnTrackerView(userWeightKg: data.weightDifference ?? 60.0)) {
                                        Text("Run")
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.gray.opacity(0.2)) // Latar belakang abu-abu lembut
                                            .foregroundColor(.black) // Teks hitam
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.8)) // Latar belakang putih lembut
                            .cornerRadius(8)
                            .padding(.horizontal, 5)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.gray.opacity(0.05)) // Latar belakang list abu-abu sangat lembut
                }
                
                Spacer()
            }
            .background(Color.white) // Latar belakang penuh putih netral
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }
        .onAppear {
            print("Loaded data count: \(dailyData.count)")
        }
    }

    @Environment(\.presentationMode) var presentationMode

    func getStatusText(data: DailyDataModel) -> String {
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

    func dateToString(_ date: Date) -> String {
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

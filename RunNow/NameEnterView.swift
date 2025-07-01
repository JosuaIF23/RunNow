//
//  NameEnterViewView.swift
//  RunNow
//
//  Created by Foundation-010 on 18/06/25.
//

import SwiftUI
import SwiftData

struct NameEnterView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var goToNext = false
    @State private var saveError: String? = nil
    
    // Enum untuk mengidentifikasi tujuan navigasi
    enum NavigationDestination {
        case bmiInput(name: String)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {

                
                Spacer()
                
                Image(.bcalTransparan)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 300)
                    .shadow(color: .shadedOrange, radius: 10)
                    .colorMultiply(.shadedOrange)
                    .padding()
                
                Spacer()
                
                VStack {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.orange)
                        Spacer()
                        TextField("Enter your name", text: $name)
                            .padding(.all)
                    }
                    .foregroundColor(.black)
                    .padding()
                    .fontWeight(.medium)
                    .frame(width: 300, height: 50)
                    .background(.white)
                    .cornerRadius(10)
                    
                    Button(action: {
                        if !name.isEmpty {
                            saveName(name: name.trimmingCharacters(in: .whitespaces))
                            if saveError == nil {
                                goToNext = true
                            }
                        } else {
                            saveError = "Name cannot be empty"
                        }
                    }) {
                        Text("Save")
                            .bold()
                            .frame(width: 300, height: 50)
                            .background(name.isEmpty ? .gray : .tombolWarna)
                            .foregroundStyle(.white)
                            .fontWeight(.medium)
                            .cornerRadius(10)
                            .padding(.all)
                    }
                    .disabled(name.isEmpty)
                    
                    if let error = saveError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 5)
                    }
                }
                .padding()
                .frame(width: 350)
                .background(.latarBelakang.opacity(0.5))
                .cornerRadius(15)
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                print("Model context: \(String(describing: modelContext))")
                print("Name field initial value: \(name)")
            }
            .navigationDestination(isPresented: $goToNext) {
                BMIInputView(name: name) // Pastikan sintaks ini lengkap
            }
        }
    }
    
    private func saveName(name: String) {
        print("Attempting to save name: \(name)")
        do {
            // Hapus data RunDataModel yang bermasalah sebelum menyimpan
            let fetchDescriptor = FetchDescriptor<RunDataModel>(sortBy: [SortDescriptor(\RunDataModel.runDate)])
            let runDataList = try modelContext.fetch(fetchDescriptor)
            for runData in runDataList where runData.dailyData == nil {
                modelContext.delete(runData)
            }
            try modelContext.save()
            print("Cleaned up orphaned RunDataModel entries")

            // Simpan data baru
            let newData = DailyDataModel(date: Date(), name: name)
            modelContext.insert(newData)
            try modelContext.save()
            print("Name saved successfully: \(newData)")
            saveError = nil
        } catch {
            print("Failed to save name: \(error.localizedDescription)")
            saveError = "Failed to save name: \(error.localizedDescription)" // Hapus karakter ';' yang salah
            modelContext.rollback() // Rollback jika gagal
        }
    }
    
    private func syncToOnline(name: String) {
        print("Syncing name '\(name)' to online database...")
    }
}

struct ColorChangingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 300, height: 50)
            .background(configuration.isPressed ? Color.orange.opacity(0.5) : Color.tombolWarna)
            .foregroundColor(.white)
            .cornerRadius(10)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    NavigationStack {
        NameEnterView()
    }
    .modelContainer(for: [DailyDataModel.self, RunDataModel.self])
}

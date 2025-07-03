//
//  StartView.swift
//  RunNow
//
//  Created by Foundation-010 on 18/06/25.
//

import SwiftUI
import _SwiftData_SwiftUI

struct StartView: View {
    @State private var isActive = false
    @State private var showNameEnter = false
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DailyDataModel.date, order: .reverse, animation: .default) private var dailyData: [DailyDataModel]
    @State private var goToParent = false

    
    private let isFirstLaunchKey = "isFirstLaunch"
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.belakang, Color.eak]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image("bcal_transparan")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 24)
                    
                    Text(dailyData.isEmpty ? "Download the app to get started" : "Tap anywhere to continue")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    
                    Spacer()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        isActive = true
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if dailyData.isEmpty || !hasCompleteData() {
                        showNameEnter = true
                    } else {
                        goToParent = true
                    }
                }

                .fullScreenCover(isPresented: $showNameEnter) {
                    NameEnterView()
                }
                .navigationDestination(isPresented: $goToParent) {
                    if let firstData = dailyData.first {
                        ParentView(name: firstData.name)
                    }
                }

            }
            .navigationBarHidden(true)
        }
    }
    
    private func hasCompleteData() -> Bool {
        guard let firstData = dailyData.first else { return false }
        return !firstData.name.isEmpty && firstData.bmi != nil && firstData.runData != nil
    }

    
    private var isFirstLaunch: Bool {
        let defaults = UserDefaults.standard
        if defaults.value(forKey: isFirstLaunchKey) == nil {
            defaults.set(false, forKey: isFirstLaunchKey)
            return true
        }
        return false
    }
}

#Preview {
    StartView()
        .modelContainer(for: [DailyDataModel.self, RunDataModel.self])
}

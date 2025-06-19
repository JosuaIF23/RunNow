//
//  NameEnter.swift
//  RunNow
//
//  Created by Foundation-010 on 19/06/25.
//

import SwiftUI

struct NameEnter: View {
    @State private var name: String = ""
    @State private var goToNext = false

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 40) {
                Text("Burn Cal App")
                    .font(.largeTitle)
                    .bold()

                TextField("Enter your name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .frame(maxWidth: 300)

                NavigationLink(destination: BMIInputView(name: name), isActive: $goToNext) {
                    EmptyView()
                }

                Button("Save") {
                    if !name.isEmpty {
                        goToNext = true
                    }
                }
                .bold()
                .padding(.vertical, 10)
                .padding(.horizontal, 40)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
    }
}


#Preview {
    NameEnter()
}

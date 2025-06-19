//
//  StartApp.swift
//  RunForBetter
//
//  Created by Foundation-010 on 16/06/25.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
              
                
                Image(systemName: "figure.run.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.orange)
                    .padding()
                
                
                Text("Ready To Get Your IDeal Body?")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)

                NavigationLink(destination: BMIInputView()) {
                    Text("Start Now")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.system(size: 24))
                  
                        
                }
            }
            .padding()
        }
    }
}

#Preview {
    StartView()
}


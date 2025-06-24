//
//  NameEnter.swift
//  RunNow
//
//  Created by Foundation-010 on 19/06/25.
//

import SwiftUI

struct NameEnter2: View {
    @State private var name: String = ""
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            
            VStack (spacing: 0){
                
//                Spacer()
            
                
                Text("Burn Call App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 30)
             
              Divider()
                    .frame(height: 1)
                    .background(Color.black)

            
    
                    VStack(spacing: 20) {
                    
                        
                        Text("Enter Your Name")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 60)
                            
                        
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .frame(maxWidth: 300)
                            .padding()

                

                        Button("Save") {
                            if !name.isEmpty {
                
                            }
                        }
                        .bold()
                        .padding(.vertical, 10)
                        .padding(.horizontal, 40)
                        .background(Color.combineBlue)
                        .foregroundColor(.customButtonBlue)
                        .cornerRadius(8)
                    }
                
                
                    .padding(.bottom,300)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.shadedWhite)
                
                
            }
        }
    }
}


#Preview {
    NameEnter2()
}

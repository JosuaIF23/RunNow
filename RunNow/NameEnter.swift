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
        //text Burn Calorie App
        VStack(spacing:10) {
            Text("Burn Calorie App")
                .font(.title)
                .fontWeight(.bold)
                .padding(.all)
            
            Spacer()
        //Logo Image
            Image(.logoOk)
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 300)
                .clipShape(Circle())
                .shadow(color: .shadedOrange, radius:10)
                .colorMultiply(.shadedOrange)
                .padding()
            
            Spacer()
            VStack{
                HStack{
                    //TextField person icon
                    Image(systemName:"person.fill")
                        .foregroundStyle(.orange)
                    Spacer()
                    TextField("Enter your name", text: $name)
                        .padding(.all)
                    
                }
                //background textfield
                .foregroundColor(.black)
                .padding()
                .fontWeight(.medium)
                .frame(width:300, height:50)
                .background(.white)
                .cornerRadius(10)
                NavigationLink(destination: BMIInputView(name: name), isActive: $goToNext) {
                    EmptyView()
                }
                //button textfields
                Button(action: {
                    if !name.isEmpty {
                        goToNext = true
                    }
                }){
                    
                    Text("Save")
                        .bold()
                        .frame(width:300, height:50)
                        .background(name.isEmpty ?.gray:.tombolWarna)
                        .foregroundStyle(.white)
                        .fontWeight(.medium)
                        .cornerRadius(10)
                        .padding(.all)
                    
                }
            }.padding()
                .frame(width:350)
                .background(.latarBelakang.opacity(0.5))
                .cornerRadius(15)
            
            Spacer()
        }
        
        
        
        .navigationBarBackButtonHidden(true)
        
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
    NavigationView{
        NameEnter()
    }
    
}

import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                
            
                VStack(spacing: 20) {
                    Spacer()
                    Text("Welcome To")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "figure.run.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.black)
                        .padding()
                    
                    Text("Burn Cal App")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
       
                NavigationLink(destination: NameEnter()) {
                    Text("Start Now")
                        .padding(.vertical, 14)
                        .padding(.horizontal, 28)
                        .background(.ultraThinMaterial)
                        .foregroundColor(.primary)
                        .font(.system(size: 18, weight: .bold))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.black.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(radius: 5)
                
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    StartView()
}

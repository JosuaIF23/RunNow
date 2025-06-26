import SwiftUI

struct StartView: View {
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

                    // Logo dengan latar belakang transparan
                    Image("bcal_transparan")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 24)

                    Spacer()
                }

                // Tombol Navigasi
                NavigationLink(destination: NameEnter()) {
                    Text("Start Now")
                        .padding(.vertical, 14)
                        .padding(.horizontal, 28)
                        .background(.biluu)
                        .foregroundColor(.primary)
                        .font(.system(size: 18, weight: .bold))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(radius: 5)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
        }
    }
}

#Preview {
    StartView()
}

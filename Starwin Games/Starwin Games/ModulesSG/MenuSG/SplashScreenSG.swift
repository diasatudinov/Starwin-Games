import SwiftUI

struct SplashScreenSG: View {
    @State private var scale: CGFloat = 1.0
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer?
    var body: some View {
        ZStack {
            Image(.splashScreenBgSG)
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                ZStack {
                    Image(.logoSG)
                        .resizable()
                        .scaledToFit()
                    
                    
                }
                .frame(height: 150)
                
                Spacer()
                
                Image(.loadingTextSG)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
                    .scaleEffect(scale)
                    .animation(
                        Animation.easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true),
                        value: scale
                    )
                    .onAppear {
                        scale = 0.8
                    }
                    .padding(.bottom, 15)
                
                ZStack {
                   
                    Image(.loaderInsideSG)
                        .resizable()
                        .scaledToFit()
                        .colorMultiply(.gray)
                    
                    Image(.loaderInsideSG)
                        .resizable()
                        .scaledToFit()
                        .mask(
                            Rectangle()
                                .frame(width: progress * 250)
                                .padding(.trailing, (1 - progress) * 250)
                        )
                    Image(.loaderBorderSG)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                }
                .frame(width: 250)
            }
            
            
        }
        .onAppear {
            startTimer()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if progress < 1 {
                progress += 0.01
            } else {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    SplashScreenSG()
}

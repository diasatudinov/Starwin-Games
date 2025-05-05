import SwiftUI

struct CoinBgSG: View {
    @StateObject var user = SGUser.shared
    var body: some View {
        ZStack {
            Image(.coinsViewBgSG)
                .resizable()
                .scaledToFit()
            
            Text("\(user.money)")
                .font(.system(size: SGDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                .foregroundStyle(.yellow)
                .textCase(.uppercase)
                .offset(x: SGDeviceManager.shared.deviceType == .pad ? 30:15, y: SGDeviceManager.shared.deviceType == .pad ? 16:8)
            
            
            
        }.frame(height: SGDeviceManager.shared.deviceType == .pad ? 126:63)
        
    }
}

#Preview {
    CoinBgSG()
}

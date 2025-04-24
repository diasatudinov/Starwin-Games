import SwiftUI

struct CoinBgSG: View {
    @StateObject var user = GEUser.shared
    var body: some View {
        ZStack {
            Image(.coinsViewBgSG)
                .resizable()
                .scaledToFit()
            
            Text("\(user.money)")
                .font(.system(size: GEDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                .foregroundStyle(.yellow)
                .textCase(.uppercase)
                .offset(x: GEDeviceManager.shared.deviceType == .pad ? 30:15, y: GEDeviceManager.shared.deviceType == .pad ? 16:8)
            
            
            
        }.frame(height: GEDeviceManager.shared.deviceType == .pad ? 126:63)
        
    }
}

#Preview {
    CoinBgSG()
}

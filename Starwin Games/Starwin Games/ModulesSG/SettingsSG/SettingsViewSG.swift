import SwiftUI
import StoreKit

struct SettingsViewSG: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var settingsVM: SettingsViewModelSG
    var body: some View {
        ZStack {
            
            ZStack {
                Image(.settingsViewBgSG)
                    .resizable()
                    .scaledToFit()
                VStack(spacing: 30) {
                    
                    Spacer()
                    HStack {
                        Image(.soundIconSG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: SGDeviceManager.shared.deviceType == .pad ? 140:70)
                        VStack {
                            Image(.soundTextSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 50:25)
                            Button {
                                withAnimation {
                                    settingsVM.soundEnabled.toggle()
                                }
                            } label: {
                                
                                Image(settingsVM.soundEnabled ? .onSG:.offSG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SGDeviceManager.shared.deviceType == .pad ? 50:25)
                            }
                        }
                    }
                    
                    HStack {
                        Image(.musicIconSG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: SGDeviceManager.shared.deviceType == .pad ? 140:70)
                        VStack {
                            Image(.musicTextSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 50:25)
                            Button {
                                withAnimation {
                                    settingsVM.musicEnabled.toggle()
                                }
                            } label: {
                                
                                Image(settingsVM.musicEnabled ? .onSG:.offSG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SGDeviceManager.shared.deviceType == .pad ? 50:25)
                            }
                        }
                    }
                    
                    HStack {
                        Image(.vibraIconSG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: SGDeviceManager.shared.deviceType == .pad ? 140:70)
                        VStack {
                            Image(.vibraTextSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 50:25)
                            Button {
                                withAnimation {
                                    settingsVM.vibraEnabled.toggle()
                                }
                            } label: {
                                
                                Image(settingsVM.vibraEnabled ? .onSG:.offSG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SGDeviceManager.shared.deviceType == .pad ? 50:25)
                            }
                        }
                    }
                    
                    Button {
                        rateUs()
                    } label: {
                        Image(.rateUsIconSG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: SGDeviceManager.shared.deviceType == .pad ? 50:120)
                    }
                }.offset(x: 0, y: 40)
                
                
            }.frame(height: SGDeviceManager.shared.deviceType == .pad ? 1000:500)
            
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.homeIconSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 150:75)
                        }
                        Spacer()
                       
                    }.padding([.horizontal, .top])
                }
                Spacer()
            }
        }.background(
            ZStack {
                Image(.settingsBgSG)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
    }
    
    func rateUs() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

#Preview {
    SettingsViewSG(settingsVM: SettingsViewModelSG())
}

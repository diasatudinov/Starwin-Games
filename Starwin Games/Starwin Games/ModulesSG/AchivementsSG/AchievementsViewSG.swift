import SwiftUI

struct AchievementsViewSG: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AchievementsViewModelSG
    var body: some View {
        ZStack {
            
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 150:75)
                        }
                        Spacer()
                    }.padding([.horizontal, .top])
                }
                VStack {
                    Image(.achievementTextSG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: SGDeviceManager.shared.deviceType == .pad ? 300:150)
                    
                    VStack {
                        
                        HStack {
                            
                            VStack {
                                Image(viewModel.achievements[0].image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SGDeviceManager.shared.deviceType == .pad ? 300:150)
                                    .opacity(viewModel.achievements[0].isAchieved ? 1 : 0.3)
                                
                                ZStack {
                                    Image(.ahivementCountBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: SGDeviceManager.shared.deviceType == .pad ? 100:50)
                                    
                                    if viewModel.achievements[0].achievedMaxCount == 1 {
                                        Text("-")
                                            .font(.system(size: SGDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                                            .foregroundStyle(.yellow)
                                    } else {
                                        Text("\(viewModel.achievements[0].achievedCount)/\(viewModel.achievements[0].achievedMaxCount)")
                                            .font(.system(size: SGDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                                            .foregroundStyle(.yellow)
                                    }
                                }
                            }
                            
                            VStack {
                                Image(viewModel.achievements[1].image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SGDeviceManager.shared.deviceType == .pad ? 300:150)
                                    .opacity(viewModel.achievements[1].isAchieved ? 1 : 0.3)
                                
                                ZStack {
                                    Image(.ahivementCountBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: SGDeviceManager.shared.deviceType == .pad ? 100:50)
                                        
                                    
                                    if viewModel.achievements[1].achievedMaxCount == 1 {
                                        Text("-")
                                            .font(.system(size: SGDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                                            .foregroundStyle(.yellow)
                                    } else {
                                        Text("\(viewModel.achievements[1].achievedCount)/\(viewModel.achievements[1].achievedMaxCount)")
                                            .font(.system(size: SGDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                                            .foregroundStyle(.yellow)
                                    }
                                }
                            }
                        }
                        
                        HStack {
                            VStack {
                                Image(viewModel.achievements[2].image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SGDeviceManager.shared.deviceType == .pad ? 300:150)
                                    .opacity(viewModel.achievements[2].isAchieved ? 1 : 0.3)
                                
                                ZStack {
                                    Image(.ahivementCountBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: SGDeviceManager.shared.deviceType == .pad ? 100:50)
                                    
                                    if viewModel.achievements[2].achievedMaxCount == 1 {
                                        Text("-")
                                            .font(.system(size: SGDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                                            .foregroundStyle(.yellow)
                                    } else {
                                        Text("\(viewModel.achievements[2].achievedCount)/\(viewModel.achievements[2].achievedMaxCount)")
                                            .font(.system(size: SGDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                                            .foregroundStyle(.yellow)
                                    }
                                }
                            }
                            
                            VStack {
                                Image(viewModel.achievements[3].image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SGDeviceManager.shared.deviceType == .pad ? 300:150)
                                    .opacity(viewModel.achievements[3].isAchieved ? 1 : 0.3)
                                
                                ZStack {
                                    Image(.ahivementCountBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: SGDeviceManager.shared.deviceType == .pad ? 100:50)
                                    
                                    if viewModel.achievements[3].achievedMaxCount == 1 {
                                        Text("-")
                                            .font(.system(size: SGDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                                            .foregroundStyle(.yellow)
                                    } else {
                                        Text("\(viewModel.achievements[3].achievedCount)/\(viewModel.achievements[3].achievedMaxCount)")
                                            .font(.system(size: SGDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                                            .foregroundStyle(.yellow)
                                    }
                                }
                            }
                        }
                        
                        
                    }
                    
                }.offset(y: SGDeviceManager.shared.deviceType == .pad ? -80:-40)
                Spacer()
            }
            
        }.background(
            ZStack {
                Image(.shopBgSG)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
    }
}

#Preview {
    AchievementsViewSG(viewModel: AchievementsViewModelSG())
}

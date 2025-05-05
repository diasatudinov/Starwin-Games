import SwiftUI


struct ShopViewSG: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var user = SGUser.shared
    @State var section: StoreSection = .skin
    @ObservedObject var viewModel: StoreViewModelSG
    @State var skinIndex: Int = 0
    @State var backIndex: Int = 0
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack {
                    }
                    
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
                            CoinBgSG()
                        }.padding([.horizontal, .top])
                    }
                }
                
                Image(.shopTextSG)
                    .resizable()
                    .scaledToFit()
                    .frame(height: SGDeviceManager.shared.deviceType == .pad ? 150:75)
                
                ZStack {
                    Image(.skinsBgSG)
                        .resizable()
                        .scaledToFit()
                    
                    HStack {
                        Button {
                            if skinIndex > 0 {
                                skinIndex -= 1
                            }
                        } label: {
                            Image(.arrowLeftIconBgSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 150:75)
                        }
                            achievementItem(item: viewModel.shopTeamItems.filter({ $0.section == .skin })[skinIndex])
                            
                        Button {
                            if skinIndex < viewModel.shopTeamItems.filter({ $0.section == .skin }).count - 1 {
                                skinIndex += 1
                            }
                        } label: {
                            Image(.arrowLeftIconBgSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 150:75)
                                .scaleEffect(x: -1,y: -1)
                        }
                    }
                }
                
                ZStack {
                    Image(.backBgSG)
                        .resizable()
                        .scaledToFit()
                    
                    HStack(spacing: 40) {
                        Button {
                            if backIndex > 0 {
                                backIndex -= 1
                            }
                        } label: {
                            Image(.arrowLeftIconBgSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 150:75)
                        }
                        achievementItem(item: viewModel.shopTeamItems.filter({ $0.section == .backgrounds })[backIndex])
                            
                        Button {
                            if backIndex < viewModel.shopTeamItems.filter({ $0.section == .backgrounds }).count - 1 {
                                backIndex += 1
                            }
                        } label: {
                            Image(.arrowLeftIconBgSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 150:75)
                                .scaleEffect(x: -1,y: -1)
                        }
                    }
                    
                }
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
    
    @ViewBuilder func achievementItem(item: Item) -> some View {
        
        ZStack {
            if item.section == .skin {
                Image(.skinBgSG)
                    .resizable()
                    .scaledToFit()
            }
            
            VStack {
                Image(item.icon)
                    .resizable()
                    .scaledToFit()
                
                Button {
                    if item.section == .skin {
                        if viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                            viewModel.currentPersonItem = item
                        } else {
                            if !viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                                
                                if user.money >= item.price {
                                    user.minusUserMoney(for: item.price)
                                    viewModel.boughtItems.append(item)
                                }
                            }
                        }
                    } else {
                        if viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                            viewModel.currentBgItem = item
                        } else {
                            if !viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                                
                                if user.money >= item.price {
                                    user.minusUserMoney(for: item.price)
                                    viewModel.boughtItems.append(item)
                                }
                            }
                        }
                    }
                } label: {
                    if item.section == .skin {
                    if viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                        VStack {
                            Spacer()
                            ZStack {
                                Image(.boughtViewSG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SGDeviceManager.shared.deviceType == .pad ? 100:50)
                                if let currentItem = viewModel.currentPersonItem, currentItem.name == item.name {
                                    Image(.selectedViewSG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: SGDeviceManager.shared.deviceType == .pad ? 100:50)
                                }
                                
                            }
                        }
                    } else {
                        VStack {
                            Spacer()
                            ZStack {
                                Image(.priceViewSG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SGDeviceManager.shared.deviceType == .pad ? 100:50)
                                
                                
                            }
                        }
                    }
                    } else {
                        if viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                            VStack {
                                Spacer()
                                ZStack {
                                    Image(.boughtViewSG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: SGDeviceManager.shared.deviceType == .pad ? 100:50)
                                    if let currentItem = viewModel.currentBgItem, currentItem.name == item.name {
                                        Image(.selectedViewSG)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: SGDeviceManager.shared.deviceType == .pad ? 100:50)
                                    }
                                    
                                }
                            }
                        } else {
                            VStack {
                                Spacer()
                                ZStack {
                                    Image(.priceViewSG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: SGDeviceManager.shared.deviceType == .pad ? 100:50)
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
            
        }.frame(height: SGDeviceManager.shared.deviceType == .pad ? 378:189)
        
    }
    
}


#Preview {
    ShopViewSG(viewModel: StoreViewModelSG())
}

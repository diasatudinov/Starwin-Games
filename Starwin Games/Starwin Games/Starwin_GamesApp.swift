import SwiftUI

@main
struct Starwin_GamesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RootSG()
                .preferredColorScheme(.light)
        }
    }
}

import SwiftUI
import FirebaseCore

@main
struct TodoFirebaseApp: App {
    // One AuthViewModel for the whole app
    @StateObject private var authVM = AuthViewModel()

    init() {
        // Reads GoogleService-Info.plist and connects the app to Firebase
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
        }
    }
}

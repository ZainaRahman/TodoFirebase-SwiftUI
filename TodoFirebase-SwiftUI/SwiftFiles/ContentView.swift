import SwiftUI

// Shows Login if logged out, NoteView if logged in
struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        if authVM.user == nil {
            LoginView()
        } else {
            NoteView()
        }
    }
}

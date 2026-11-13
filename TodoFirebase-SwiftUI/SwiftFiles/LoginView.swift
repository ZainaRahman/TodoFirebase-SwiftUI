import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "checklist")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            Text(isSignUp ? "Create Account" : "Welcome Back")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))

            SecureField("Password (min 6 characters)", text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))

            if !authVM.errorMessage.isEmpty {
                Text(authVM.errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            Button {
                Task {
                    if isSignUp {
                        await authVM.signUp(email: email, password: password)
                    } else {
                        await authVM.signIn(email: email, password: password)
                    }
                }
            } label: {
                Text(isSignUp ? "Sign Up" : "Log In")
                    .bold()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
            }
            .disabled(email.isEmpty || password.count < 6)

            Button(isSignUp ? "Already have an account? Log in" : "No account? Sign up") {
                isSignUp.toggle()
            }
            .font(.footnote)

            Spacer()
        }
        .padding()
    }
}

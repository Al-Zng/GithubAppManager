import SwiftUI

struct LoginView: View {
    @AppStorage("github_pat") var githubPAT: String = ""
    @State private var inputToken: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "apple.terminal.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                
                Text("GitHub Manager")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Enter your Personal Access Token")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                SecureField("ghp_xxxxxxxxxxxx", text: $inputToken)
                    .padding()
                    .background(Color(white: 0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                
                Button(action: {
                    if !inputToken.isEmpty {
                        githubPAT = inputToken
                    }
                }) {
                    Text("Connect")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
            }
        }
    }
}

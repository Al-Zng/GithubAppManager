import SwiftUI

@main
struct GitHubManagerApp: App {
    // التحقق من وجود توكن محفوظ مسبقاً
    @AppStorage("github_pat") var githubPAT: String = ""

    var body: some Scene {
        WindowGroup {
            if githubPAT.isEmpty {
                LoginView()
                    .preferredColorScheme(.dark)
            } else {
                NavigationView {
                    RepoListView()
                }
                .preferredColorScheme(.dark)
            }
        }
    }
}

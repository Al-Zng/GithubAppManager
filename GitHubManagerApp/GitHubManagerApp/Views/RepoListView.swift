import SwiftUI

struct RepoListView: View {
    @StateObject private var api = GitHubAPI()
    @State private var repositories: [Repository] = []
    @State private var isLoading = true
    @AppStorage("github_pat") var githubPAT: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                List(repositories) { repo in
                    NavigationLink(destination: RepoDetailView(repository: repo)) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(repo.name)
                                .font(.headline)
                                .foregroundColor(.white)
                            if let desc = repo.description {
                                Text(desc)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .listRowBackground(Color.black)
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Repositories")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Logout") {
                    githubPAT = ""
                }
                .foregroundColor(.red)
            }
        }
        .onAppear {
            api.fetchRepositories { repos in
                if let repos = repos {
                    self.repositories = repos
                }
                self.isLoading = false
            }
        }
    }
}

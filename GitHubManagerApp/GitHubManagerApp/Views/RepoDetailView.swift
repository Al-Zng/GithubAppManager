import SwiftUI

struct RepoDetailView: View {
    let repository: Repository
    @StateObject private var api = GitHubAPI()
    @State private var contents: [RepoContent] = []
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            List(contents) { item in
                if item.type == "dir" {
                    NavigationLink(destination: Text("Subfolder Navigation coming soon")) {
                        HStack {
                            Image(systemName: "folder.fill").foregroundColor(.blue)
                            Text(item.name).foregroundColor(.white)
                        }
                    }
                    .listRowBackground(Color.black)
                } else {
                    NavigationLink(destination: CodeEditorView(fileURL: item.downloadUrl ?? "", fileName: item.name)) {
                        HStack {
                            Image(systemName: "doc.text.fill").foregroundColor(.gray)
                            Text(item.name).foregroundColor(.white)
                        }
                    }
                    .listRowBackground(Color.black)
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle(repository.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ZipManagerView(repository: repository)) {
                    Image(systemName: "shippingbox.fill")
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            let owner = repository.fullName.components(separatedBy: "/").first ?? ""
            api.fetchContents(owner: owner, repo: repository.name) { fetchedContents in
                if let fetchedContents = fetchedContents {
                    self.contents = fetchedContents.sorted { $0.type > $1.type } // المجلدات أولاً
                }
            }
        }
    }
}

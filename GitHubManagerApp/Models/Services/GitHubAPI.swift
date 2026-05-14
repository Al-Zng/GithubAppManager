import Foundation
import SwiftUI

class GitHubAPI: ObservableObject {
    @AppStorage("github_pat") var token: String = ""
    let baseURL = "https://api.github.com"
    
    func fetchRepositories(completion: @escaping ([Repository]?) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/repos?sort=updated") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let repos = try JSONDecoder().decode([Repository].self, from: data)
                DispatchQueue.main.async { completion(repos) }
            } catch {
                print("Error decoding repos: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    func fetchContents(owner: String, repo: String, path: String = "", completion: @escaping ([RepoContent]?) -> Void) {
        guard let url = URL(string: "\(baseURL)/repos/\(owner)/\(repo)/contents/\(path)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                // إذا كان المسار ملف واحد، سيرجع كائن واحد، إذا كان مجلد سيرجع مصفوفة
                if let array = try? JSONDecoder().decode([RepoContent].self, from: data) {
                    DispatchQueue.main.async { completion(array) }
                } else if let singleFile = try? JSONDecoder().decode(RepoContent.self, from: data) {
                    DispatchQueue.main.async { completion([singleFile]) }
                } else {
                    DispatchQueue.main.async { completion(nil) }
                }
            }
        }.resume()
    }
    
    func downloadFileContent(url: String, completion: @escaping (String?) -> Void) {
        guard let fetchUrl = URL(string: url) else { return }
        var request = URLRequest(url: fetchUrl)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            let content = String(data: data, encoding: .utf8)
            DispatchQueue.main.async { completion(content) }
        }.resume()
    }
}

import SwiftUI

struct CodeEditorView: View {
    let fileURL: String
    let fileName: String
    @StateObject private var api = GitHubAPI()
    @State private var codeText: String = ""
    @State private var isLoading = true
    
    var body: some View {
        VStack(spacing: 0) {
            // شريط الأدوات المخصص (Editor Toolbar)
            HStack {
                Button(action: {
                    // يحاكي تحديد الكل برمجياً (يتطلب Custom UITextView للتطبيق الفعلي، لكن هنا نستخدم المنطق العام)
                    UIPasteboard.general.string = codeText
                }) {
                    Image(systemName: "doc.on.doc")
                    Text("Copy All")
                }
                .foregroundColor(.white)
                .font(.caption)
                
                Spacer()
                
                Button(action: {
                    if let pasted = UIPasteboard.general.string {
                        codeText += pasted
                    }
                }) {
                    Image(systemName: "doc.on.clipboard")
                    Text("Paste")
                }
                .foregroundColor(.white)
                .font(.caption)
                
                Spacer()
                
                Button(action: {
                    codeText = ""
                }) {
                    Image(systemName: "trash")
                    Text("Clear")
                }
                .foregroundColor(.red)
                .font(.caption)
            }
            .padding()
            .background(Color(white: 0.1))
            
            // المحرر
            if isLoading {
                Spacer()
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                Spacer()
            } else {
                TextEditor(text: $codeText)
                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden) // إخفاء خلفية السكرول الافتراضية
                    .background(Color.black)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle(fileName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    // هنا يتم استدعاء دالة الرفع للـ GitHub API عبر Base64 Encoding
                    print("Saving code... Implement Commit API here")
                }
                .foregroundColor(.green)
            }
        }
        .onAppear {
            api.downloadFileContent(url: fileURL) { content in
                if let content = content {
                    self.codeText = content
                }
                self.isLoading = false
            }
        }
    }
}

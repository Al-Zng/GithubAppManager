import SwiftUI
import UniformTypeIdentifiers

struct ZipManagerView: View {
    let repository: Repository
    @State private var isImporting = false
    @State private var selectedFileURL: URL?
    @State private var showOptions = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "doc.zipper")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.orange)
                
                Text("Upload Zip to \(repository.name)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    isImporting = true
                }) {
                    HStack {
                        Image(systemName: "folder.badge.plus")
                        Text("Select .zip File")
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                }
                
                if let url = selectedFileURL {
                    Text("Selected: \(url.lastPathComponent)")
                        .foregroundColor(.green)
                        .font(.footnote)
                    
                    VStack(spacing: 15) {
                        Button(action: {
                            // المنطق البرمجي: استخراج الـ Zip ورفع كل الملفات بعد حذف القديمة (Commit API)
                            print("Replacing entire repository...")
                        }) {
                            Text("1. Replace Entire Repository")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            // المنطق البرمجي: استخراج الـ Zip، مقارنة الهاش (SHA) لكل ملف، ورفع المحدث فقط (Commit API)
                            print("Updating only modified files...")
                        }) {
                            Text("2. Update Only Modified Files")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [UTType.zip],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                if selectedFile.startAccessingSecurityScopedResource() {
                    self.selectedFileURL = selectedFile
                    // يجب استدعاء selectedFile.stopAccessingSecurityScopedResource() عند الانتهاء من فك الضغط
                }
            } catch {
                print("Error selecting file: \(error.localizedDescription)")
            }
        }
        .navigationTitle("Zip Upload")
        .navigationBarTitleDisplayMode(.inline)
    }
}

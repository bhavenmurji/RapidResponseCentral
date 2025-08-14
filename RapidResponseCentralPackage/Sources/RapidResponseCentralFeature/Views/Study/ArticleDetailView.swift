import SwiftUI

public struct ArticleDetailView: View {
    let article: StudyArticle
    @ObservedObject var service: StudyProtocolService
    @State private var fontSize: CGFloat = 16
    @State private var showingKeyPoints = true
    @Environment(\.dismiss) private var dismiss
    
    public init(article: StudyArticle, service: StudyProtocolService) {
        self.article = article
        self.service = service
    }
    
    var isBookmarked: Bool {
        service.studyProgress.bookmarkedItems.contains(article.id)
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Article Header
                VStack(alignment: .leading, spacing: 12) {
                    Text(article.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(spacing: 16) {
                        Label(article.category, systemImage: "folder")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Label(article.date, systemImage: "calendar")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Label("\(article.readingTime) min read", systemImage: "clock")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Key Points Section
                if !article.keyPoints.isEmpty {
                    DisclosureGroup("Key Points", isExpanded: $showingKeyPoints) {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(article.keyPoints, id: \.self) { point in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                        .padding(.top, 2)
                                    
                                    Text(point)
                                        .font(.subheadline)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                // Article Content
                Text(article.content)
                    .font(.system(size: fontSize))
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Placeholder for full content
                VStack(alignment: .leading, spacing: 16) {
                    Text("Full Article Content")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text("The complete article content would be loaded here from the FamMedCentral markdown files. This would include detailed medical information, evidence-based recommendations, diagnostic criteria, treatment options, and clinical pearls.")
                        .font(.system(size: fontSize))
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    // Font Size Control
                    Menu {
                        Button(action: { fontSize = 14 }) {
                            Label("Small", systemImage: "textformat.size.smaller")
                        }
                        Button(action: { fontSize = 16 }) {
                            Label("Medium", systemImage: "textformat.size")
                        }
                        Button(action: { fontSize = 18 }) {
                            Label("Large", systemImage: "textformat.size.larger")
                        }
                    } label: {
                        Image(systemName: "textformat.size")
                    }
                    
                    // Bookmark Button
                    Button(action: {
                        service.toggleBookmark(article.id)
                    }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(isBookmarked ? .orange : .primary)
                    }
                }
            }
        }
        .onAppear {
            service.markArticleAsRead(article.id)
        }
    }
}
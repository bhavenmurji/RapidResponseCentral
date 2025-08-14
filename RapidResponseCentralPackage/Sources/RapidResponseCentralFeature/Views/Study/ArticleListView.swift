import SwiftUI

public struct ArticleListView: View {
    @ObservedObject var service: StudyProtocolService
    @State private var searchText = ""
    @State private var selectedYear: Int?
    @State private var selectedCategory: String?
    
    var filteredArticles: [StudyArticle] {
        var articles = service.articles
        
        if !searchText.isEmpty {
            articles = articles.filter { article in
                article.title.localizedCaseInsensitiveContains(searchText) ||
                article.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let year = selectedYear {
            articles = articles.filter { $0.year == year }
        }
        
        if let category = selectedCategory {
            articles = articles.filter { $0.category == category }
        }
        
        return articles
    }
    
    var categories: [String] {
        Array(Set(service.articles.map { $0.category })).sorted()
    }
    
    var years: [Int] {
        Array(Set(service.articles.map { $0.year })).sorted(by: >)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Filter Bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterChip(
                        title: "All Years",
                        isSelected: selectedYear == nil,
                        action: { selectedYear = nil }
                    )
                    
                    ForEach(years, id: \.self) { year in
                        FilterChip(
                            title: "\(year)",
                            isSelected: selectedYear == year,
                            action: { selectedYear = year }
                        )
                    }
                    
                    Divider()
                        .frame(height: 20)
                    
                    FilterChip(
                        title: "All Topics",
                        isSelected: selectedCategory == nil,
                        action: { selectedCategory = nil }
                    )
                    
                    ForEach(categories, id: \.self) { category in
                        FilterChip(
                            title: category,
                            isSelected: selectedCategory == category,
                            action: { selectedCategory = category }
                        )
                    }
                }
                .padding()
            }
            .background(Color(.systemBackground))
            
            Divider()
            
            // Articles List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredArticles) { article in
                        NavigationLink(destination: ArticleDetailView(article: article, service: service)) {
                            ArticleRowView(article: article, service: service)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("AAFP Articles")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search articles...")
    }
}

struct ArticleRowView: View {
    let article: StudyArticle
    @ObservedObject var service: StudyProtocolService
    
    var isRead: Bool {
        service.studyProgress.completedArticles.contains(article.id)
    }
    
    var isBookmarked: Bool {
        service.studyProgress.bookmarkedItems.contains(article.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(article.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if isRead {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                }
                
                if isBookmarked {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                }
            }
            
            HStack {
                Label(article.category, systemImage: "folder")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Label(article.date, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Label("\(article.readingTime) min", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            if !article.keyPoints.isEmpty {
                Text(article.keyPoints.first ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(15)
        }
    }
}
import SwiftUI

public struct StudyHomeView: View {
    @StateObject private var service = StudyProtocolService()
    @State private var selectedCategory: StudyCategory?
    @State private var searchText = ""
    @State private var showingProgress = false
    @State private var isRefreshing = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Main content in ScrollView
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Show loading state if loading
                        if service.isLoading && service.categories.isEmpty {
                            StudyLoadingView()
                                .frame(maxWidth: .infinity, minHeight: 400)
                                .transition(.opacity.combined(with: .scale))
                        } else if showError {
                            // Error State
                            StudyErrorStateView(error: errorMessage) {
                                refreshContent()
                            }
                            .frame(maxWidth: .infinity, minHeight: 400)
                            .transition(.opacity.combined(with: .scale))
                        } else if service.categories.isEmpty && service.articles.isEmpty {
                            // Empty State
                            StudyEmptyStateView(
                                title: "No Study Materials",
                                message: "Study content is being prepared. Check back soon!",
                                icon: "books.vertical",
                                action: refreshContent
                            )
                            .frame(maxWidth: .infinity, minHeight: 400)
                            .transition(.opacity.combined(with: .scale))
                        } else {
                            // Content Available
                            // Progress Summary Card with animation
                            ProgressSummaryCard(service: service)
                                .padding(.horizontal)
                                .transition(.asymmetric(
                                    insertion: .slide.combined(with: .opacity),
                                    removal: .opacity
                                ))
                            
                            // Study Categories Grid with polished cards
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Study Resources")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    if isRefreshing {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                            .scaleEffect(0.8)
                                    }
                                }
                                .padding(.horizontal)
                                
                                if service.isLoading {
                                    // Show skeleton loaders while loading
                                    LazyVGrid(columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ], spacing: 16) {
                                        ForEach(0..<4) { _ in
                                            SkeletonCategoryCard()
                                        }
                                    }
                                    .padding(.horizontal)
                                } else {
                                    // Show actual content with polished cards
                                    LazyVGrid(columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ], spacing: 16) {
                                        ForEach(service.categories) { category in
                                            NavigationLink(destination: destinationView(for: category)) {
                                                PolishedCategoryCard(category: category)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            .transition(.asymmetric(
                                                insertion: .scale(scale: 0.9).combined(with: .opacity),
                                                removal: .opacity
                                            ))
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        
                        // Recent Activity Section
                        RecentActivitySection(service: service)
                            .padding(.horizontal)
                        
                        // Topics Section
                        TopicsSection(topics: service.topics)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    await refreshContent()
                }
                
                // Emergency Support Card - Fixed at bottom, outside ScrollView
                EmergencySupportCard()
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
            .navigationTitle("Study")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search articles, questions...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingProgress.toggle() }) {
                        Image(systemName: "chart.bar.fill")
                    }
                }
            }
            .sheet(isPresented: $showingProgress) {
                StudyProgressView(service: service)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for category: StudyCategory) -> some View {
        switch category.type {
        case .articles:
            ArticleListView(service: service)
        case .iteQuestions, .cmeQuestions, .flashcards:
            QuestionBankView(service: service, type: category.type)
        case .topics:
            TopicBrowseView(service: service)
        }
    }
    
    private func refreshContent() {
        // Haptic feedback for refresh
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        isRefreshing = true
        showError = false
        
        // Simulate refresh with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                isRefreshing = false
            }
        }
    }
}

// MARK: - Supporting Views

struct StudyCategoryCard: View {
    let category: StudyCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(colorForCategory(category.color))
                
                Spacer()
                
                Text("\(category.itemCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(category.title)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Text(category.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func colorForCategory(_ color: String) -> Color {
        switch color {
        case "blue": return .blue
        case "green": return .green
        case "purple": return .purple
        case "orange": return .orange
        default: return .blue
        }
    }
}

struct ProgressSummaryCard: View {
    @ObservedObject var service: StudyProtocolService
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Your Progress")
                    .font(.headline)
                Spacer()
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.blue)
            }
            
            let stats = service.getProgressStats()
            
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("\(stats.articlesRead)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Articles Read")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .frame(height: 40)
                
                VStack(alignment: .leading) {
                    Text("\(stats.questionsAnswered)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Questions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .frame(height: 40)
                
                VStack(alignment: .leading) {
                    Text("\(Int(stats.correctRate * 100))%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Correct")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct RecentActivitySection: View {
    @ObservedObject var service: StudyProtocolService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Continue Learning")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if service.articles.isEmpty {
                Text("Start exploring study materials")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            } else {
                ForEach(service.articles.prefix(2)) { article in
                    NavigationLink(destination: ArticleDetailView(article: article, service: service)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(article.title)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                
                                HStack {
                                    Text(article.category)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text("•")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text("\(article.readingTime) min")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}

struct TopicsSection: View {
    let topics: [StudyTopic]
    @State private var showingAllTopics = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Browse by Topic")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: { showingAllTopics.toggle() }) {
                    Text("See All")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(topics.prefix(5)) { topic in
                        NavigationLink(destination: TopicDetailView(topic: topic)) {
                            VStack(spacing: 8) {
                                Image(systemName: topic.icon)
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    .frame(width: 50, height: 50)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                                
                                Text(topic.name)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                
                                Text("\(topic.articleCount)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: 80)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StudyHomeView()
}
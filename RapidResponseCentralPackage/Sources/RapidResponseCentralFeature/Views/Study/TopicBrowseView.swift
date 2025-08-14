import SwiftUI

public struct TopicBrowseView: View {
    @ObservedObject var service: StudyProtocolService
    @State private var searchText = ""
    
    var filteredTopics: [StudyTopic] {
        if searchText.isEmpty {
            return service.topics
        } else {
            return service.topics.filter { topic in
                topic.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(filteredTopics) { topic in
                    NavigationLink(destination: TopicDetailView(topic: topic)) {
                        TopicCardView(topic: topic)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Browse by Topic")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search topics...")
    }
}

struct TopicCardView: View {
    let topic: StudyTopic
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: topic.icon)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .frame(height: 50)
            
            Text(topic.name)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                VStack {
                    Text("\(topic.articleCount)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("Articles")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .frame(height: 30)
                
                VStack {
                    Text("\(topic.questionCount)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("Questions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 160)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

public struct TopicDetailView: View {
    let topic: StudyTopic
    @State private var selectedTab = 0
    
    public var body: some View {
        VStack(spacing: 0) {
            // Topic Header
            VStack(spacing: 12) {
                Image(systemName: topic.icon)
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                
                Text(topic.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack(spacing: 20) {
                    Label("\(topic.articleCount) Articles", systemImage: "doc.text")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Label("\(topic.questionCount) Questions", systemImage: "questionmark.circle")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            
            // Tab Selection
            Picker("Content", selection: $selectedTab) {
                Text("Overview").tag(0)
                Text("Articles").tag(1)
                Text("Questions").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Content
            ScrollView {
                switch selectedTab {
                case 0:
                    TopicOverviewView(topic: topic)
                case 1:
                    TopicArticlesView(topic: topic)
                case 2:
                    TopicQuestionsView(topic: topic)
                default:
                    EmptyView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TopicOverviewView: View {
    let topic: StudyTopic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Subcategories
            VStack(alignment: .leading, spacing: 12) {
                Text("Subcategories")
                    .font(.headline)
                
                ForEach(topic.subcategories, id: \.self) { subcategory in
                    HStack {
                        Image(systemName: "arrow.right.circle")
                            .foregroundColor(.blue)
                        
                        Text(subcategory)
                            .font(.subheadline)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
            
            // Learning Resources
            VStack(alignment: .leading, spacing: 12) {
                Text("Learning Resources")
                    .font(.headline)
                
                HStack {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text("\(topic.articleCount) Articles")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("Comprehensive coverage of key topics")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text("\(topic.questionCount) Practice Questions")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("Test your knowledge")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct TopicArticlesView: View {
    let topic: StudyTopic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Articles in \(topic.name)")
                .font(.headline)
                .padding(.horizontal)
            
            Text("Loading articles for this topic...")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

struct TopicQuestionsView: View {
    let topic: StudyTopic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Practice Questions in \(topic.name)")
                .font(.headline)
                .padding(.horizontal)
            
            Text("Loading questions for this topic...")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
        }
        .padding(.vertical)
    }
}
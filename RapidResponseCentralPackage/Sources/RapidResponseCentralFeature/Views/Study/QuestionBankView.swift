import SwiftUI

public struct QuestionBankView: View {
    @ObservedObject var service: StudyProtocolService
    let type: StudyContentType
    @State private var selectedDifficulty: DifficultyLevel?
    @State private var selectedTopic: String?
    @State private var showOnlyUnanswered = false
    @State private var searchText = ""
    
    var filteredQuestions: [StudyQuestion] {
        var questions = service.questions.filter { question in
            switch type {
            case .iteQuestions:
                return question.type == .ite
            case .flashcards:
                return question.type == .flashcard
            default:
                return true
            }
        }
        
        if !searchText.isEmpty {
            questions = questions.filter { question in
                question.question.localizedCaseInsensitiveContains(searchText) ||
                (question.topic?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        if let difficulty = selectedDifficulty {
            questions = questions.filter { $0.difficulty == difficulty }
        }
        
        if let topic = selectedTopic {
            questions = questions.filter { $0.topic == topic }
        }
        
        if showOnlyUnanswered {
            questions = questions.filter { question in
                !service.studyProgress.answeredQuestions.contains(question.questionId)
            }
        }
        
        return questions
    }
    
    var topics: [String] {
        Array(Set(service.questions.compactMap { $0.topic })).sorted()
    }
    
    var answeredCount: Int {
        service.studyProgress.answeredQuestions.count
    }
    
    var correctCount: Int {
        service.studyProgress.correctAnswers.count
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Statistics Bar
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("\(filteredQuestions.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Questions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .frame(height: 30)
                
                VStack(alignment: .leading) {
                    Text("\(answeredCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("Answered")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .frame(height: 30)
                
                VStack(alignment: .leading) {
                    let percentage = answeredCount > 0 ? (correctCount * 100 / answeredCount) : 0
                    Text("\(percentage)%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Correct")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Toggle("Unanswered", isOn: $showOnlyUnanswered)
                    .font(.caption)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            .padding()
            .background(Color(.systemBackground))
            
            // Filter Options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // Difficulty filters
                    FilterChip(
                        title: "All Levels",
                        isSelected: selectedDifficulty == nil,
                        action: { selectedDifficulty = nil }
                    )
                    
                    ForEach(DifficultyLevel.allCases, id: \.self) { difficulty in
                        FilterChip(
                            title: difficulty.rawValue,
                            isSelected: selectedDifficulty == difficulty,
                            action: { selectedDifficulty = difficulty }
                        )
                    }
                    
                    Divider()
                        .frame(height: 20)
                    
                    // Topic filters
                    FilterChip(
                        title: "All Topics",
                        isSelected: selectedTopic == nil,
                        action: { selectedTopic = nil }
                    )
                    
                    ForEach(topics, id: \.self) { topic in
                        FilterChip(
                            title: topic,
                            isSelected: selectedTopic == topic,
                            action: { selectedTopic = topic }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            Divider()
            
            // Questions List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredQuestions) { question in
                        NavigationLink(destination: QuestionDetailView(question: question, service: service)) {
                            QuestionRowView(question: question, service: service)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(type == .iteQuestions ? "ITE Questions" : "CME Flashcards")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search questions...")
    }
}

struct QuestionRowView: View {
    let question: StudyQuestion
    @ObservedObject var service: StudyProtocolService
    
    var isAnswered: Bool {
        service.studyProgress.answeredQuestions.contains(question.questionId)
    }
    
    var isCorrect: Bool {
        service.studyProgress.correctAnswers.contains(question.questionId)
    }
    
    var isBookmarked: Bool {
        service.studyProgress.bookmarkedItems.contains(question.questionId)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(question.questionId)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(question.question)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    if isAnswered {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(isCorrect ? .green : .red)
                    }
                    
                    if isBookmarked {
                        Image(systemName: "bookmark.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                }
            }
            
            HStack {
                Label(question.topic ?? "General", systemImage: "folder")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Label(question.difficulty.rawValue, systemImage: "gauge")
                    .font(.caption)
                    .foregroundColor(colorForDifficulty(question.difficulty))
                
                if !question.relatedArticles.isEmpty {
                    Label("\(question.relatedArticles.count) articles", systemImage: "doc.text")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private func colorForDifficulty(_ difficulty: DifficultyLevel) -> Color {
        switch difficulty {
        case .easy:
            return .green
        case .medium:
            return .orange
        case .hard:
            return .red
        }
    }
}
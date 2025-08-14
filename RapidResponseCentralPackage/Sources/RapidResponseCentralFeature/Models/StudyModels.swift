import Foundation
import SwiftUI

// MARK: - Study Content Models

public struct StudyCategory: Identifiable, Sendable {
    public let id = UUID()
    public let title: String
    public let icon: String
    public let description: String
    public let color: String
    public var itemCount: Int
    public let type: StudyContentType
}

public enum StudyContentType: String, CaseIterable, Sendable {
    case articles = "Articles"
    case iteQuestions = "ITE Questions"
    case cmeQuestions = "CME Questions"
    case flashcards = "Flashcards"
    case topics = "Topics"
    
    public var icon: String {
        switch self {
        case .articles: return "doc.text.fill"
        case .iteQuestions: return "questionmark.circle.fill"
        case .cmeQuestions: return "graduationcap.fill"
        case .flashcards: return "rectangle.stack.fill"
        case .topics: return "folder.fill"
        }
    }
    
    public var color: Color {
        switch self {
        case .articles: return .blue
        case .iteQuestions: return .purple
        case .cmeQuestions: return .green
        case .flashcards: return .orange
        case .topics: return .teal
        }
    }
}

// MARK: - Article Models

public struct StudyArticle: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let date: String
    public let category: String
    public let content: String
    public let year: Int
    public let month: String
    public let readingTime: Int // in minutes
    public let keyPoints: [String]
    public let journal: String
    public let pdfAvailable: Bool
    public let originalPdf: String?
    public let tags: [String]
    public let isRead: Bool
    public let isFavorite: Bool
    public let lastAccessed: Date?
    
    public init(
        id: String? = nil,
        title: String,
        date: String,
        category: String,
        content: String,
        year: Int,
        month: String,
        readingTime: Int = 10,
        keyPoints: [String] = [],
        journal: String = "American Family Physician",
        pdfAvailable: Bool = false,
        originalPdf: String? = nil,
        tags: [String] = [],
        isRead: Bool = false,
        isFavorite: Bool = false,
        lastAccessed: Date? = nil
    ) {
        self.id = id ?? "\(year)-\(month)-\(title.lowercased().replacingOccurrences(of: " ", with: "-"))"
        self.title = title
        self.date = date
        self.category = category
        self.content = content
        self.year = year
        self.month = month
        self.readingTime = readingTime
        self.keyPoints = keyPoints
        self.journal = journal
        self.pdfAvailable = pdfAvailable
        self.originalPdf = originalPdf
        self.tags = tags
        self.isRead = isRead
        self.isFavorite = isFavorite
        self.lastAccessed = lastAccessed
    }
}

// MARK: - Question Models

public struct StudyQuestion: Identifiable, Sendable {
    public let id: String
    public let questionId: String // e.g., "ITE-2024-001"
    public let type: QuestionType
    public let year: Int
    public let number: Int
    public let question: String
    public let stem: String?
    public let options: [QuestionOption]
    public let correctAnswer: String // Option ID (A, B, C, D, E)
    public let explanation: String
    public let relatedArticles: [RelatedArticle]
    public let topic: String?
    public let difficulty: DifficultyLevel
    public let tags: [String]
    public let isAnswered: Bool
    public let selectedAnswer: String?
    public let isFlagged: Bool
    public let timeSpent: TimeInterval
    
    public init(
        id: String? = nil,
        questionId: String,
        type: QuestionType,
        year: Int,
        number: Int,
        question: String,
        stem: String? = nil,
        options: [QuestionOption],
        correctAnswer: String,
        explanation: String,
        relatedArticles: [RelatedArticle] = [],
        topic: String? = nil,
        difficulty: DifficultyLevel = .medium,
        tags: [String] = [],
        isAnswered: Bool = false,
        selectedAnswer: String? = nil,
        isFlagged: Bool = false,
        timeSpent: TimeInterval = 0
    ) {
        self.id = id ?? questionId
        self.questionId = questionId
        self.type = type
        self.year = year
        self.number = number
        self.question = question
        self.stem = stem
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.relatedArticles = relatedArticles
        self.topic = topic
        self.difficulty = difficulty
        self.tags = tags
        self.isAnswered = isAnswered
        self.selectedAnswer = selectedAnswer
        self.isFlagged = isFlagged
        self.timeSpent = timeSpent
    }
}

public struct QuestionOption: Identifiable, Hashable, Sendable {
    public let id: String // A, B, C, D, E
    public let text: String
    public let isCorrect: Bool
    
    public init(id: String, text: String, isCorrect: Bool = false) {
        self.id = id
        self.text = text
        self.isCorrect = isCorrect
    }
}

public enum QuestionType: String, CaseIterable, Sendable {
    case ite = "ITE"
    case cme = "CME"
    case boardReview = "Board Review"
    case practice = "Practice"
    case flashcard = "Flashcard"
    
    public var displayName: String {
        switch self {
        case .ite: return "In-Training Exam"
        case .cme: return "CME Questions"
        case .boardReview: return "Board Review"
        case .practice: return "Practice Questions"
        case .flashcard: return "Flashcards"
        }
    }
    
    public var color: Color {
        switch self {
        case .ite: return .blue
        case .cme: return .green
        case .boardReview: return .purple
        case .practice: return .orange
        case .flashcard: return .pink
        }
    }
}

public enum DifficultyLevel: String, CaseIterable, Sendable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    public var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
}

public struct RelatedArticle: Hashable, Sendable {
    public let title: String
    public let path: String
    public let similarity: Double
    public let year: Int?
    public let month: String?
    
    public init(title: String, path: String, similarity: Double, year: Int? = nil, month: String? = nil) {
        self.title = title
        self.path = path
        self.similarity = similarity
        self.year = year
        self.month = month
    }
}

// MARK: - Topic Models

public struct StudyTopic: Identifiable, Sendable {
    public let id = UUID()
    public let name: String
    public let icon: String
    public let articleCount: Int
    public let questionCount: Int
    public let subcategories: [String]
    public let color: Color
    
    public init(
        name: String,
        icon: String,
        articleCount: Int = 0,
        questionCount: Int = 0,
        subcategories: [String] = [],
        color: Color = .blue
    ) {
        self.name = name
        self.icon = icon
        self.articleCount = articleCount
        self.questionCount = questionCount
        self.subcategories = subcategories
        self.color = color
    }
}

// MARK: - Study Session Models

public struct StudySession: Identifiable, Codable, Sendable {
    public let id = UUID()
    public let startTime: Date
    public var endTime: Date?
    public let sessionType: StudySessionType
    public var questionsAnswered: Int
    public var correctAnswers: Int
    public var articlesRead: Int
    public var topics: Set<String>
    
    public var duration: TimeInterval {
        guard let endTime = endTime else {
            return Date().timeIntervalSince(startTime)
        }
        return endTime.timeIntervalSince(startTime)
    }
    
    public var accuracy: Double {
        guard questionsAnswered > 0 else { return 0 }
        return Double(correctAnswers) / Double(questionsAnswered) * 100
    }
    
    public init(
        sessionType: StudySessionType,
        questionsAnswered: Int = 0,
        correctAnswers: Int = 0,
        articlesRead: Int = 0,
        topics: Set<String> = []
    ) {
        self.startTime = Date()
        self.sessionType = sessionType
        self.questionsAnswered = questionsAnswered
        self.correctAnswers = correctAnswers
        self.articlesRead = articlesRead
        self.topics = topics
    }
}

public enum StudySessionType: String, Codable, CaseIterable, Sendable {
    case practice = "Practice"
    case timed = "Timed"
    case tutor = "Tutor"
    case review = "Review"
    case reading = "Reading"
    
    public var icon: String {
        switch self {
        case .practice: return "pencil.circle.fill"
        case .timed: return "timer.circle.fill"
        case .tutor: return "graduationcap.circle.fill"
        case .review: return "checkmark.circle.fill"
        case .reading: return "book.circle.fill"
        }
    }
}

// MARK: - Study Progress Tracking

public struct StudyProgress: Codable, Sendable {
    public var completedArticles: Set<String>
    public var answeredQuestions: Set<String>
    public var correctAnswers: Set<String>
    public var bookmarkedItems: Set<String>
    public var lastAccessedDate: Date
    public var totalStudyTime: TimeInterval
    public var streakDays: Int
    public var topicProgress: [String: TopicProgress]
    
    public var totalQuestionsAnswered: Int {
        answeredQuestions.count
    }
    
    public var totalCorrectAnswers: Int {
        correctAnswers.count
    }
    
    public var overallAccuracy: Double {
        guard totalQuestionsAnswered > 0 else { return 0 }
        return Double(totalCorrectAnswers) / Double(totalQuestionsAnswered) * 100
    }
    
    public init() {
        self.completedArticles = []
        self.answeredQuestions = []
        self.correctAnswers = []
        self.bookmarkedItems = []
        self.lastAccessedDate = Date()
        self.totalStudyTime = 0
        self.streakDays = 0
        self.topicProgress = [:]
    }
}

public struct TopicProgress: Codable, Hashable, Sendable {
    public let topic: String
    public var questionsAnswered: Int
    public var correctAnswers: Int
    public var articlesRead: Int
    public var lastStudied: Date
    
    public var accuracy: Double {
        guard questionsAnswered > 0 else { return 0 }
        return Double(correctAnswers) / Double(questionsAnswered) * 100
    }
    
    public init(
        topic: String,
        questionsAnswered: Int = 0,
        correctAnswers: Int = 0,
        articlesRead: Int = 0,
        lastStudied: Date = Date()
    ) {
        self.topic = topic
        self.questionsAnswered = questionsAnswered
        self.correctAnswers = correctAnswers
        self.articlesRead = articlesRead
        self.lastStudied = lastStudied
    }
}

// MARK: - Search and Filter

public struct StudySearchFilter: Sendable {
    public var searchText: String = ""
    public var contentType: StudyContentType?
    public var topic: String?
    public var year: Int?
    public var month: String?
    public var difficulty: DifficultyLevel?
    public var questionType: QuestionType?
    public var showOnlyBookmarked: Bool = false
    public var showOnlyUnanswered: Bool = false
    public var showOnlyUnread: Bool = false
    public var sortBy: SortOption = .newest
    
    public enum SortOption: String, CaseIterable, Sendable {
        case newest = "Newest First"
        case oldest = "Oldest First"
        case alphabetical = "A-Z"
        case difficulty = "Difficulty"
        case relevance = "Relevance"
    }
}
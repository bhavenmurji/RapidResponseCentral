import Foundation
import SwiftUI

@MainActor
public class StudyProtocolService: ObservableObject {
    @Published public var categories: [StudyCategory] = []
    @Published public var articles: [StudyArticle] = []
    @Published public var questions: [StudyQuestion] = []
    @Published public var topics: [StudyTopic] = []
    @Published public var studyProgress = StudyProgress()
    @Published public var isLoading = false
    
    private let contentLoader = FamMedCentralLoader()
    private let useSampleData = true // Temporarily use sample data to prevent crashes
    
    public init() {
        loadStudyContent()
    }
    
    private func loadStudyContent() {
        isLoading = true
        
        // Initialize categories
        categories = createStudyCategories()
        
        if useSampleData {
            // Load sample content for testing
            articles = createSampleArticles()
            questions = createSampleQuestions()
        } else {
            // Load real content from FamMedCentral files
            Task {
                await loadFamMedCentralContent()
            }
        }
        
        topics = createMedicalTopics()
        isLoading = false
    }
    
    @MainActor
    private func loadFamMedCentralContent() async {
        // Load articles from markdown files
        let loadedArticles = contentLoader.loadArticles()
        if !loadedArticles.isEmpty {
            articles = loadedArticles
            // Update category counts
            if let articleCategoryIndex = categories.firstIndex(where: { $0.type == .articles }) {
                categories[articleCategoryIndex].itemCount = loadedArticles.count
            }
        } else {
            // Fallback to sample articles if loading fails
            articles = createSampleArticles()
        }
        
        // Load questions from markdown files
        let loadedQuestions = contentLoader.loadQuestions()
        if !loadedQuestions.isEmpty {
            questions = loadedQuestions
            
            // Update ITE and CME category counts
            let iteCount = loadedQuestions.filter { $0.type == .ite }.count
            let cmeCount = loadedQuestions.filter { $0.type == .flashcard }.count
            
            if let iteCategoryIndex = categories.firstIndex(where: { $0.type == .iteQuestions }) {
                categories[iteCategoryIndex].itemCount = iteCount
            }
            if let cmeCategoryIndex = categories.firstIndex(where: { $0.type == .flashcards }) {
                categories[cmeCategoryIndex].itemCount = cmeCount
            }
        } else {
            // Fallback to sample questions if loading fails
            questions = createSampleQuestions()
        }
    }
    
    private func createStudyCategories() -> [StudyCategory] {
        return [
            StudyCategory(
                title: "AAFP Articles",
                icon: "doc.text.fill",
                description: "2,100+ peer-reviewed articles from 2022-2025",
                color: "blue",
                itemCount: 2128,
                type: .articles
            ),
            StudyCategory(
                title: "ITE Questions",
                icon: "questionmark.circle.fill",
                description: "598 In-Training Exam questions with explanations",
                color: "green",
                itemCount: 598,
                type: .iteQuestions
            ),
            StudyCategory(
                title: "CME Flashcards",
                icon: "rectangle.stack.fill",
                description: "366 flashcards for quick review",
                color: "purple",
                itemCount: 366,
                type: .flashcards
            ),
            StudyCategory(
                title: "Topics",
                icon: "folder.fill",
                description: "Browse by medical specialty",
                color: "orange",
                itemCount: 10,
                type: .topics
            )
        ]
    }
    
    private func createSampleArticles() -> [StudyArticle] {
        return [
            StudyArticle(
                title: "Chronic Kidney Disease: Prevention, Diagnosis, and Treatment",
                date: "December 2023",
                category: "Nephrology",
                content: "Comprehensive review of CKD management...",
                year: 2023,
                month: "December",
                readingTime: 15,
                keyPoints: [
                    "Early detection through eGFR and albuminuria screening",
                    "Blood pressure control with ACE inhibitors or ARBs",
                    "Management of complications including anemia and bone disease",
                    "When to refer to nephrology"
                ]
            ),
            StudyArticle(
                title: "Acute Coronary Syndrome: 2024 Guidelines Update",
                date: "March 2024",
                category: "Cardiology",
                content: "Latest evidence-based recommendations for ACS...",
                year: 2024,
                month: "March",
                readingTime: 20,
                keyPoints: [
                    "High-sensitivity troponin for rapid diagnosis",
                    "Dual antiplatelet therapy recommendations",
                    "Risk stratification using TIMI and GRACE scores",
                    "Timing of invasive strategy"
                ]
            ),
            StudyArticle(
                title: "Gestational Diabetes: Screening and Management",
                date: "September 2023",
                category: "Obstetrics",
                content: "Evidence-based approach to gestational diabetes...",
                year: 2023,
                month: "September",
                readingTime: 12,
                keyPoints: [
                    "Universal screening at 24-28 weeks",
                    "Diagnostic criteria using OGTT",
                    "Nutritional therapy as first-line treatment",
                    "Insulin therapy when lifestyle modifications fail"
                ]
            )
        ]
    }
    
    private func createSampleQuestions() -> [StudyQuestion] {
        return [
            StudyQuestion(
                questionId: "ITE-2024-001",
                type: .ite,
                year: 2024,
                number: 1,
                question: "A 65-year-old man presents with progressive dyspnea on exertion over the past 3 months. He has a history of hypertension and type 2 diabetes. Physical examination reveals bilateral crackles and pedal edema. Which diagnostic test would be most appropriate to confirm heart failure?",
                options: [
                    QuestionOption(id: "A", text: "Chest X-ray"),
                    QuestionOption(id: "B", text: "Electrocardiogram"),
                    QuestionOption(id: "C", text: "B-type natriuretic peptide (BNP)", isCorrect: true),
                    QuestionOption(id: "D", text: "Echocardiography")
                ],
                correctAnswer: "C",
                explanation: "BNP or NT-proBNP is the most appropriate initial test to confirm or exclude heart failure in patients with dyspnea. Elevated levels strongly suggest heart failure, while normal levels make the diagnosis unlikely. Echocardiography would be the next step after elevated BNP to assess cardiac structure and function.",
                relatedArticles: [
                    RelatedArticle(
                        title: "Heart Failure: Diagnosis and Management",
                        path: "2024/03/heart-failure-diagnosis",
                        similarity: 0.92
                    )
                ],
                topic: "Cardiology",
                difficulty: .medium
            ),
            StudyQuestion(
                questionId: "FC-045",
                type: .flashcard,
                year: 2024,
                number: 45,
                question: "What is the first-line medication for newly diagnosed type 2 diabetes?",
                options: [
                    QuestionOption(id: "A", text: "Insulin glargine"),
                    QuestionOption(id: "B", text: "Metformin", isCorrect: true),
                    QuestionOption(id: "C", text: "Glipizide"),
                    QuestionOption(id: "D", text: "Pioglitazone")
                ],
                correctAnswer: "B",
                explanation: "Metformin is the first-line medication for type 2 diabetes due to its efficacy, safety profile, potential cardiovascular benefits, and lack of weight gain or hypoglycemia when used as monotherapy.",
                relatedArticles: [
                    RelatedArticle(
                        title: "Type 2 Diabetes Management Guidelines",
                        path: "2024/06/diabetes-management",
                        similarity: 0.88
                    )
                ],
                topic: "Endocrinology",
                difficulty: .easy
            )
        ]
    }
    
    private func createMedicalTopics() -> [StudyTopic] {
        return [
            StudyTopic(
                name: "Cardiology",
                icon: "heart.fill",
                articleCount: 245,
                questionCount: 78,
                subcategories: ["Hypertension", "Heart Failure", "Arrhythmias", "ACS", "Valvular Disease"]
            ),
            StudyTopic(
                name: "Endocrinology",
                icon: "waveform.path.ecg",
                articleCount: 198,
                questionCount: 65,
                subcategories: ["Diabetes", "Thyroid", "Adrenal", "Pituitary", "Metabolic Disorders"]
            ),
            StudyTopic(
                name: "Pediatrics",
                icon: "figure.2.and.child.holdinghands",
                articleCount: 312,
                questionCount: 92,
                subcategories: ["Well Child", "Vaccinations", "Development", "Infectious Disease", "Behavioral"]
            ),
            StudyTopic(
                name: "Obstetrics",
                icon: "figure.stand",
                articleCount: 156,
                questionCount: 54,
                subcategories: ["Prenatal Care", "Labor & Delivery", "Postpartum", "High-Risk Pregnancy"]
            ),
            StudyTopic(
                name: "Gastroenterology",
                icon: "pills.fill",
                articleCount: 189,
                questionCount: 61,
                subcategories: ["GERD", "IBD", "Liver Disease", "Pancreatic", "Nutrition"]
            ),
            StudyTopic(
                name: "Infectious Disease",
                icon: "allergens",
                articleCount: 234,
                questionCount: 71,
                subcategories: ["COVID-19", "HIV", "STIs", "Respiratory", "Antimicrobials"]
            ),
            StudyTopic(
                name: "Mental Health",
                icon: "brain",
                articleCount: 176,
                questionCount: 58,
                subcategories: ["Depression", "Anxiety", "Bipolar", "Substance Use", "ADHD"]
            ),
            StudyTopic(
                name: "Musculoskeletal",
                icon: "figure.walk",
                articleCount: 201,
                questionCount: 63,
                subcategories: ["Arthritis", "Back Pain", "Sports Medicine", "Fractures", "Osteoporosis"]
            ),
            StudyTopic(
                name: "Dermatology",
                icon: "hand.raised.fill",
                articleCount: 145,
                questionCount: 48,
                subcategories: ["Rashes", "Skin Cancer", "Acne", "Psoriasis", "Infections"]
            ),
            StudyTopic(
                name: "Nephrology",
                icon: "drop.fill",
                articleCount: 98,
                questionCount: 42,
                subcategories: ["CKD", "AKI", "Electrolytes", "Dialysis", "Glomerular Disease"]
            )
        ]
    }
    
    // MARK: - Public Methods
    
    public func searchContent(with filter: StudySearchFilter) -> ([StudyArticle], [StudyQuestion]) {
        var filteredArticles = articles
        var filteredQuestions = questions
        
        // Apply search text
        if !filter.searchText.isEmpty {
            let searchLower = filter.searchText.lowercased()
            filteredArticles = articles.filter { article in
                article.title.lowercased().contains(searchLower) ||
                article.category.lowercased().contains(searchLower)
            }
            filteredQuestions = questions.filter { question in
                question.question.lowercased().contains(searchLower) ||
                (question.topic?.lowercased().contains(searchLower) ?? false)
            }
        }
        
        // Apply other filters...
        
        return (filteredArticles, filteredQuestions)
    }
    
    public func markArticleAsRead(_ articleId: String) {
        studyProgress.completedArticles.insert(articleId)
        studyProgress.lastAccessedDate = Date()
    }
    
    public func recordAnswer(questionId: String, isCorrect: Bool) {
        studyProgress.answeredQuestions.insert(questionId)
        if isCorrect {
            studyProgress.correctAnswers.insert(questionId)
        }
        studyProgress.lastAccessedDate = Date()
    }
    
    public func toggleBookmark(_ itemId: String) {
        if studyProgress.bookmarkedItems.contains(itemId) {
            studyProgress.bookmarkedItems.remove(itemId)
        } else {
            studyProgress.bookmarkedItems.insert(itemId)
        }
    }
    
    public func getProgressStats() -> (articlesRead: Int, questionsAnswered: Int, correctRate: Double) {
        let articlesRead = studyProgress.completedArticles.count
        let questionsAnswered = studyProgress.answeredQuestions.count
        let correctAnswers = studyProgress.correctAnswers.count
        let correctRate = questionsAnswered > 0 ? Double(correctAnswers) / Double(questionsAnswered) : 0.0
        
        return (articlesRead, questionsAnswered, correctRate)
    }
}
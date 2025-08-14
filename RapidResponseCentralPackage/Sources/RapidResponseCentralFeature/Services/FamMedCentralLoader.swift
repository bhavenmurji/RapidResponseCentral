import Foundation
import SwiftUI

@MainActor
public class FamMedCentralLoader: ObservableObject {
    private let basePath = "/Users/bhavenmurji/Development/RapidResponseCentral/Assets/FamMedCentral"
    
    // MARK: - Article Loading
    
    public func loadArticles() -> [StudyArticle] {
        var articles: [StudyArticle] = []
        let articlesPath = "\(basePath)/Articles"
        
        print("Loading articles from: \(articlesPath)")
        
        // Load articles from each year
        for year in [2023, 2024, 2025] {
            let yearPath = "\(articlesPath)/\(year)"
            let yearArticles = loadArticlesFromYear(yearPath: yearPath, year: year)
            print("Loaded \(yearArticles.count) articles from year \(year)")
            articles.append(contentsOf: yearArticles)
        }
        
        print("Total articles loaded: \(articles.count)")
        return articles
    }
    
    private func loadArticlesFromYear(yearPath: String, year: Int) -> [StudyArticle] {
        var articles: [StudyArticle] = []
        let fileManager = FileManager.default
        
        // Get all month directories
        guard let monthDirs = try? fileManager.contentsOfDirectory(atPath: yearPath) else {
            return articles
        }
        
        for monthDir in monthDirs where monthDir != "Icon" {
            let monthPath = "\(yearPath)/\(monthDir)"
            
            // Get all markdown files in month directory
            guard let files = try? fileManager.contentsOfDirectory(atPath: monthPath) else {
                continue
            }
            
            for file in files where file.hasSuffix(".md") {
                let filePath = "\(monthPath)/\(file)"
                if let article = loadArticleFromFile(filePath: filePath, year: year, month: monthDir) {
                    articles.append(article)
                }
            }
        }
        
        return articles
    }
    
    private func loadArticleFromFile(filePath: String, year: Int, month: String) -> StudyArticle? {
        guard let content = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            return nil
        }
        
        // Parse YAML frontmatter and content
        let parts = content.components(separatedBy: "---")
        guard parts.count >= 3 else { return nil }
        
        let frontmatter = parts[1]
        let articleContent = parts[2...].joined(separator: "---").trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Extract metadata from frontmatter
        var title = ""
        var journal = "American Family Physician"
        
        for line in frontmatter.components(separatedBy: "\n") {
            if line.contains("title:") {
                title = line.replacingOccurrences(of: "title:", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            } else if line.contains("journal:") {
                journal = line.replacingOccurrences(of: "journal:", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            }
        }
        
        // Extract key points from content (first few bullet points if available)
        let keyPoints = extractKeyPoints(from: articleContent)
        
        // Determine category based on title
        let category = determineCategory(from: title)
        
        // Calculate reading time (roughly 200 words per minute)
        let wordCount = articleContent.components(separatedBy: .whitespacesAndNewlines).count
        let readingTime = max(1, wordCount / 200)
        
        return StudyArticle(
            title: title.isEmpty ? "Untitled Article" : title,
            date: "\(getMonthName(month)) \(year)",
            category: category,
            content: String(articleContent.prefix(500)) + "...", // Preview content
            year: year,
            month: getMonthName(month),
            readingTime: readingTime,
            keyPoints: keyPoints,
            fullContent: articleContent,
            journal: journal,
            filePath: filePath
        )
    }
    
    // MARK: - Question Loading
    
    public func loadQuestions() -> [StudyQuestion] {
        var questions: [StudyQuestion] = []
        
        print("Loading questions from: \(basePath)/QuestionBank")
        
        // Load ITE questions
        let iteQuestions = loadQuestionsFromDirectory(
            path: "\(basePath)/QuestionBank/ITE",
            type: .ite
        )
        print("Loaded \(iteQuestions.count) ITE questions")
        questions.append(contentsOf: iteQuestions)
        
        // Load CME flashcards
        let cmeQuestions = loadQuestionsFromDirectory(
            path: "\(basePath)/QuestionBank/CME",
            type: .flashcard
        )
        print("Loaded \(cmeQuestions.count) CME flashcards")
        questions.append(contentsOf: cmeQuestions)
        
        print("Total questions loaded: \(questions.count)")
        return questions
    }
    
    private func loadQuestionsFromDirectory(path: String, type: QuestionType) -> [StudyQuestion] {
        var questions: [StudyQuestion] = []
        let fileManager = FileManager.default
        
        guard let files = try? fileManager.contentsOfDirectory(atPath: path) else {
            return questions
        }
        
        for file in files where file.hasSuffix(".md") {
            let filePath = "\(path)/\(file)"
            if let question = loadQuestionFromFile(filePath: filePath, type: type) {
                questions.append(question)
            }
        }
        
        return questions
    }
    
    private func loadQuestionFromFile(filePath: String, type: QuestionType) -> StudyQuestion? {
        guard let content = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            return nil
        }
        
        // Parse YAML frontmatter and content
        let parts = content.components(separatedBy: "---")
        guard parts.count >= 3 else { return nil }
        
        let frontmatter = parts[1]
        let questionContent = parts[2...].joined(separator: "---").trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Extract metadata from frontmatter
        var questionId = ""
        var topic: String? = nil
        var answer = ""
        var relatedArticles: [RelatedArticle] = []
        
        for line in frontmatter.components(separatedBy: "\n") {
            if line.contains("id:") {
                questionId = line.replacingOccurrences(of: "id:", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            } else if line.contains("topic:") {
                topic = line.replacingOccurrences(of: "topic:", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            } else if line.contains("answer:") {
                answer = line.replacingOccurrences(of: "answer:", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        // Parse related articles from frontmatter
        if frontmatter.contains("related_articles:") {
            relatedArticles = parseRelatedArticles(from: frontmatter)
        }
        
        // Parse question text and options from content
        let lines = questionContent.components(separatedBy: "\n")
        var questionText = ""
        var options: [QuestionOption] = []
        var explanation = ""
        var inOptions = false
        var inExplanation = false
        
        for line in lines {
            if line.hasPrefix("# Question") || line.hasPrefix("## Question") {
                continue
            } else if line.hasPrefix("## Options") || line.hasPrefix("# Options") {
                inOptions = true
                inExplanation = false
            } else if line.hasPrefix("## Explanation") || line.hasPrefix("# Explanation") {
                inOptions = false
                inExplanation = true
            } else if inOptions && (line.hasPrefix("A.") || line.hasPrefix("B.") || line.hasPrefix("C.") || line.hasPrefix("D.") || line.hasPrefix("E.")) {
                let optionId = String(line.prefix(1))
                let optionText = line.dropFirst(2).trimmingCharacters(in: .whitespacesAndNewlines)
                options.append(QuestionOption(
                    id: optionId,
                    text: optionText,
                    isCorrect: optionId == answer
                ))
            } else if inExplanation {
                explanation += line + "\n"
            } else if !inOptions && !inExplanation && !line.isEmpty {
                questionText += line + " "
            }
        }
        
        // Determine difficulty based on question complexity
        let difficulty = determineDifficulty(from: questionText)
        
        // Extract year and number from questionId
        let year = extractYear(from: questionId)
        let number = extractNumber(from: questionId)
        
        return StudyQuestion(
            questionId: questionId,
            type: type,
            year: year,
            number: number,
            question: questionText.trimmingCharacters(in: .whitespacesAndNewlines),
            options: options,
            correctAnswer: answer,
            explanation: explanation.trimmingCharacters(in: .whitespacesAndNewlines),
            relatedArticles: relatedArticles,
            topic: topic,
            difficulty: difficulty
        )
    }
    
    // MARK: - Helper Methods
    
    private func extractKeyPoints(from content: String) -> [String] {
        var keyPoints: [String] = []
        let lines = content.components(separatedBy: "\n")
        
        for line in lines {
            if line.hasPrefix("- ") || line.hasPrefix("• ") || line.hasPrefix("* ") {
                let point = line.dropFirst(2).trimmingCharacters(in: .whitespacesAndNewlines)
                if !point.isEmpty && keyPoints.count < 5 {
                    keyPoints.append(point)
                }
            }
        }
        
        return keyPoints
    }
    
    private func determineCategory(from title: String) -> String {
        let lowercased = title.lowercased()
        
        if lowercased.contains("cardio") || lowercased.contains("heart") || lowercased.contains("hypertens") {
            return "Cardiology"
        } else if lowercased.contains("diabet") || lowercased.contains("endocrin") || lowercased.contains("thyroid") {
            return "Endocrinology"
        } else if lowercased.contains("child") || lowercased.contains("pediatr") || lowercased.contains("infant") {
            return "Pediatrics"
        } else if lowercased.contains("pregnan") || lowercased.contains("obstet") || lowercased.contains("gestation") {
            return "Obstetrics"
        } else if lowercased.contains("mental") || lowercased.contains("depress") || lowercased.contains("anxiety") {
            return "Mental Health"
        } else if lowercased.contains("cancer") || lowercased.contains("oncolog") || lowercased.contains("tumor") {
            return "Oncology"
        } else if lowercased.contains("infect") || lowercased.contains("virus") || lowercased.contains("bacteria") {
            return "Infectious Disease"
        } else {
            return "General Medicine"
        }
    }
    
    private func determineDifficulty(from text: String) -> DifficultyLevel {
        let wordCount = text.components(separatedBy: .whitespacesAndNewlines).count
        
        if wordCount < 50 {
            return .easy
        } else if wordCount < 100 {
            return .medium
        } else {
            return .hard
        }
    }
    
    private func parseRelatedArticles(from frontmatter: String) -> [RelatedArticle] {
        var articles: [RelatedArticle] = []
        let lines = frontmatter.components(separatedBy: "\n")
        
        var inRelatedArticles = false
        var currentArticle: [String: String] = [:]
        
        for line in lines {
            if line.contains("related_articles:") {
                inRelatedArticles = true
            } else if inRelatedArticles {
                if line.contains("- title:") {
                    if !currentArticle.isEmpty {
                        if let title = currentArticle["title"],
                           let path = currentArticle["path"],
                           let similarityStr = currentArticle["similarity"],
                           let similarity = Double(similarityStr) {
                            articles.append(RelatedArticle(
                                title: title,
                                path: path,
                                similarity: similarity
                            ))
                        }
                    }
                    currentArticle = [:]
                    currentArticle["title"] = line.replacingOccurrences(of: "- title:", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                } else if line.contains("  title:") {
                    currentArticle["title"] = line.replacingOccurrences(of: "  title:", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                } else if line.contains("  path:") {
                    currentArticle["path"] = line.replacingOccurrences(of: "  path:", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                } else if line.contains("  similarity:") {
                    currentArticle["similarity"] = line.replacingOccurrences(of: "  similarity:", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
        
        // Add last article if exists
        if !currentArticle.isEmpty {
            if let title = currentArticle["title"],
               let path = currentArticle["path"],
               let similarityStr = currentArticle["similarity"],
               let similarity = Double(similarityStr) {
                articles.append(RelatedArticle(
                    title: title,
                    path: path,
                    similarity: similarity
                ))
            }
        }
        
        return articles
    }
    
    private func getMonthName(_ month: String) -> String {
        switch month {
        case "01": return "January"
        case "02": return "February"
        case "03": return "March"
        case "04": return "April"
        case "05": return "May"
        case "06": return "June"
        case "07": return "July"
        case "08": return "August"
        case "09": return "September"
        case "10": return "October"
        case "11": return "November"
        case "12": return "December"
        default: return month
        }
    }
    
    private func extractYear(from id: String) -> Int {
        // Extract year from IDs like "ITE-2024-001" or "FC-001"
        let components = id.components(separatedBy: "-")
        for component in components {
            if let year = Int(component), year >= 2000 && year <= 2030 {
                return year
            }
        }
        return 2024 // Default year
    }
    
    private func extractNumber(from id: String) -> Int {
        // Extract number from IDs like "ITE-2024-001" or "FC-001"
        let components = id.components(separatedBy: "-")
        if let lastComponent = components.last, let number = Int(lastComponent) {
            return number
        }
        return 1 // Default number
    }
}

// MARK: - Extended StudyArticle
extension StudyArticle {
    init(title: String, date: String, category: String, content: String, year: Int, month: String, readingTime: Int, keyPoints: [String], fullContent: String? = nil, journal: String? = nil, filePath: String? = nil) {
        self.init(
            title: title,
            date: date,
            category: category,
            content: content,
            year: year,
            month: month,
            readingTime: readingTime,
            keyPoints: keyPoints
        )
        // Note: In a real implementation, you'd add these properties to the StudyArticle model
    }
}
import SwiftUI

public struct QuestionDetailView: View {
    let question: StudyQuestion
    @ObservedObject var service: StudyProtocolService
    @State private var selectedAnswer: String?
    @State private var showingExplanation = false
    @State private var hasAnswered = false
    @Environment(\.dismiss) private var dismiss
    
    var isBookmarked: Bool {
        service.studyProgress.bookmarkedItems.contains(question.questionId)
    }
    
    var isCorrect: Bool {
        selectedAnswer == question.correctAnswer
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Question Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(question.questionId)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray5))
                            .cornerRadius(4)
                        
                        Text(question.type.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray5))
                            .cornerRadius(4)
                        
                        Text(question.difficulty.rawValue)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(backgroundForDifficulty(question.difficulty))
                            .cornerRadius(4)
                        
                        Spacer()
                    }
                    
                    Text(question.topic ?? "General")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Question Text
                Text(question.question)
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                
                Divider()
                    .padding(.horizontal)
                
                // Answer Options
                VStack(spacing: 12) {
                    ForEach(Array(question.options.enumerated()), id: \.element.id) { index, option in
                        AnswerOptionView(
                            option: option,
                            index: index,
                            isSelected: selectedAnswer == option.id,
                            isCorrect: option.id == question.correctAnswer,
                            hasAnswered: hasAnswered,
                            action: {
                                if !hasAnswered {
                                    selectedAnswer = option.id
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
                
                // Submit Button
                if selectedAnswer != nil && !hasAnswered {
                    Button(action: submitAnswer) {
                        Text("Submit Answer")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                // Result and Explanation
                if hasAnswered {
                    VStack(alignment: .leading, spacing: 16) {
                        // Result
                        HStack {
                            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(isCorrect ? .green : .red)
                            
                            Text(isCorrect ? "Correct!" : "Incorrect")
                                .font(.headline)
                                .foregroundColor(isCorrect ? .green : .red)
                            
                            Spacer()
                        }
                        .padding()
                        .background(isCorrect ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                        .cornerRadius(10)
                        
                        // Explanation
                        DisclosureGroup("Explanation", isExpanded: $showingExplanation) {
                            Text(question.explanation)
                                .font(.body)
                                .padding(.top, 8)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        // Related Articles
                        if !question.relatedArticles.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Related Articles")
                                    .font(.headline)
                                
                                ForEach(question.relatedArticles, id: \.path) { article in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(article.title)
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                        
                                        HStack {
                                            Text("Relevance: \(Int(article.similarity * 100))%")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            
                                            Spacer()
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        
                        // Next Question Button
                        Button(action: {
                            // Navigate to next question or back to list
                            dismiss()
                        }) {
                            Text("Next Question")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    service.toggleBookmark(question.questionId)
                }) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(isBookmarked ? .orange : .primary)
                }
            }
        }
    }
    
    private func submitAnswer() {
        hasAnswered = true
        showingExplanation = true
        
        if let selectedAnswer = selectedAnswer {
            let isCorrect = selectedAnswer == question.correctAnswer
            service.recordAnswer(questionId: question.questionId, isCorrect: isCorrect)
        }
    }
    
    private func backgroundForDifficulty(_ difficulty: DifficultyLevel) -> Color {
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

struct AnswerOptionView: View {
    let option: QuestionOption
    let index: Int
    let isSelected: Bool
    let isCorrect: Bool
    let hasAnswered: Bool
    let action: () -> Void
    
    private var optionLetter: String {
        option.id
    }
    
    private var backgroundColor: Color {
        if hasAnswered {
            if isCorrect {
                return Color.green.opacity(0.2)
            } else if isSelected && !isCorrect {
                return Color.red.opacity(0.2)
            }
        } else if isSelected {
            return Color.blue.opacity(0.2)
        }
        return Color(.systemGray6)
    }
    
    private var borderColor: Color {
        if hasAnswered {
            if isCorrect {
                return Color.green
            } else if isSelected && !isCorrect {
                return Color.red
            }
        } else if isSelected {
            return Color.blue
        }
        return Color.clear
    }
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Text(optionLetter)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(width: 30, height: 30)
                    .background(Circle().fill(Color(.systemGray5)))
                
                Text(option.text)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                if hasAnswered {
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else if isSelected && !isCorrect {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 2)
            )
            .cornerRadius(10)
        }
        .disabled(hasAnswered)
    }
}
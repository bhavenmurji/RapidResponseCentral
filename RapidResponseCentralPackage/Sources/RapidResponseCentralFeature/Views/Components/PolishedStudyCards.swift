import SwiftUI

// MARK: - Enhanced Category Card with Animations
public struct PolishedCategoryCard: View {
    let category: StudyCategory
    @State private var isPressed = false
    @State private var isHovered = false
    @Namespace private var animation
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with icon and count
            HStack {
                // Animated Icon Container
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    colorForCategory(category.color).opacity(0.2),
                                    colorForCategory(category.color).opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(colorForCategory(category.color))
                        .scaleEffect(isHovered ? 1.1 : 1)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovered)
                }
                
                Spacer()
                
                // Animated Count Badge
                Text("\(category.itemCount)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(colorForCategory(category.color))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(colorForCategory(category.color).opacity(0.15))
                    )
                    .scaleEffect(isPressed ? 0.95 : 1)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(category.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(category.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Progress Indicator (if applicable)
            if category.type == .articles || category.type == .iteQuestions {
                ProgressBarView(progress: Double.random(in: 0.2...0.8), color: colorForCategory(category.color))
                    .frame(height: 4)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(isHovered ? 0.15 : 0.08),
                    radius: isHovered ? 12 : 8,
                    x: 0,
                    y: isHovered ? 6 : 4
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colorForCategory(category.color).opacity(isHovered ? 0.3 : 0),
                            colorForCategory(category.color).opacity(isHovered ? 0.1 : 0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .scaleEffect(isPressed ? 0.97 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .animation(.easeOut(duration: 0.2), value: isHovered)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    private func colorForCategory(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "blue": return .blue
        case "green": return .green
        case "purple": return .purple
        case "orange": return .orange
        case "red": return .red
        case "teal": return .teal
        default: return .blue
        }
    }
}

// MARK: - Progress Bar View
struct ProgressBarView: View {
    let progress: Double
    let color: Color
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 2)
                    .fill(color.opacity(0.2))
                    .frame(height: 4)
                
                // Progress
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * animatedProgress, height: 4)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animatedProgress)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animatedProgress = progress
            }
        }
    }
}

// MARK: - Enhanced Article Card
public struct PolishedArticleCard: View {
    let article: StudyArticle
    @State private var isExpanded = false
    @State private var isBookmarked = false
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(article.category)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                    
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(isExpanded ? nil : 2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                // Bookmark Button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isBookmarked.toggle()
                    }
                    
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 18))
                        .foregroundColor(isBookmarked ? .orange : .gray)
                        .scaleEffect(isBookmarked ? 1.2 : 1)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isBookmarked)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Metadata
            HStack(spacing: 12) {
                Label(article.date, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Label("\(article.readingTime) min", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if article.pdfAvailable {
                    Label("PDF", systemImage: "doc.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            // Content Preview
            if isExpanded {
                Text(article.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                
                // Key Points
                if !article.keyPoints.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Key Points")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        ForEach(article.keyPoints, id: \.self) { point in
                            HStack(alignment: .top, spacing: 8) {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 4, height: 4)
                                    .offset(y: 6)
                                
                                Text(point)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.top, 8)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            
            // Expand/Collapse Button
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(isExpanded ? "Show Less" : "Show More")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(isExpanded ? 0 : 0))
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Question Card with Animation
public struct PolishedQuestionCard: View {
    let question: StudyQuestion
    @State private var isFlipped = false
    @State private var rotation: Double = 0
    
    public var body: some View {
        ZStack {
            // Front of card (Question)
            if !isFlipped {
                VStack(alignment: .leading, spacing: 12) {
                    // Header
                    HStack {
                        Label(question.type.displayName, systemImage: "questionmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(question.type.color)
                        
                        Spacer()
                        
                        DifficultyBadge(level: question.difficulty)
                    }
                    
                    // Question Text
                    Text(question.question)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(4)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    // Flip Button
                    Button(action: flipCard) {
                        HStack {
                            Text("Show Answer")
                                .font(.caption)
                                .fontWeight(.medium)
                            
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.caption)
                        }
                        .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                )
                .rotation3DEffect(
                    .degrees(rotation),
                    axis: (x: 0, y: 1, z: 0)
                )
            } else {
                // Back of card (Answer)
                VStack(alignment: .leading, spacing: 12) {
                    // Header
                    HStack {
                        Label("Answer", systemImage: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        Button(action: flipCard) {
                            Image(systemName: "arrow.uturn.left.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Correct Answer
                    Text("Correct: Option \(question.correctAnswer)")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    // Explanation
                    Text(question.explanation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(4)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.green.opacity(0.05),
                                    Color.blue.opacity(0.05)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                )
                .rotation3DEffect(
                    .degrees(rotation + 180),
                    axis: (x: 0, y: 1, z: 0)
                )
            }
        }
        .frame(height: 200)
    }
    
    private func flipCard() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            rotation += 180
            isFlipped.toggle()
        }
    }
}

// MARK: - Difficulty Badge
struct DifficultyBadge: View {
    let level: DifficultyLevel
    
    var body: some View {
        Text(level.rawValue)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(level.color)
            .cornerRadius(6)
    }
}
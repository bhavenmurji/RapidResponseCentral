import SwiftUI
import Charts

public struct StudyProgressView: View {
    @ObservedObject var service: StudyProtocolService
    @Environment(\.dismiss) private var dismiss
    
    var stats: (articlesRead: Int, questionsAnswered: Int, correctRate: Double) {
        service.getProgressStats()
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Overall Progress
                    OverallProgressCard(stats: stats)
                    
                    // Progress Charts
                    ProgressChartsSection(service: service)
                    
                    // Achievements
                    AchievementsSection(stats: stats)
                    
                    // Study Streaks
                    StudyStreakCard()
                    
                    // Bookmarked Items
                    BookmarkedItemsSection(service: service)
                }
                .padding()
            }
            .navigationTitle("Study Progress")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct OverallProgressCard: View {
    let stats: (articlesRead: Int, questionsAnswered: Int, correctRate: Double)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Overall Progress")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 20) {
                ProgressMetric(
                    value: "\(stats.articlesRead)",
                    label: "Articles Read",
                    color: .blue,
                    icon: "doc.text.fill"
                )
                
                ProgressMetric(
                    value: "\(stats.questionsAnswered)",
                    label: "Questions",
                    color: .green,
                    icon: "questionmark.circle.fill"
                )
                
                ProgressMetric(
                    value: "\(Int(stats.correctRate * 100))%",
                    label: "Accuracy",
                    color: .orange,
                    icon: "target"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct ProgressMetric: View {
    let value: String
    let label: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProgressChartsSection: View {
    @ObservedObject var service: StudyProtocolService
    
    // Sample data for demonstration
    let weeklyData = [
        (day: "Mon", articles: 3, questions: 5),
        (day: "Tue", articles: 2, questions: 8),
        (day: "Wed", articles: 4, questions: 6),
        (day: "Thu", articles: 1, questions: 10),
        (day: "Fri", articles: 5, questions: 7),
        (day: "Sat", articles: 2, questions: 4),
        (day: "Sun", articles: 3, questions: 9)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Activity")
                .font(.headline)
            
            if #available(iOS 16.0, *) {
                Chart(weeklyData, id: \.day) { data in
                    BarMark(
                        x: .value("Day", data.day),
                        y: .value("Articles", data.articles)
                    )
                    .foregroundStyle(.blue)
                    
                    BarMark(
                        x: .value("Day", data.day),
                        y: .value("Questions", data.questions)
                    )
                    .foregroundStyle(.green)
                    .position(by: .value("Type", "Questions"))
                }
                .frame(height: 200)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            } else {
                // Fallback for older iOS versions
                SimpleBarChart(data: weeklyData)
            }
        }
    }
}

struct SimpleBarChart: View {
    let data: [(day: String, articles: Int, questions: Int)]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(data, id: \.day) { item in
                VStack(spacing: 4) {
                    VStack(spacing: 2) {
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: 30, height: CGFloat(item.questions * 10))
                        
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 30, height: CGFloat(item.articles * 10))
                    }
                    
                    Text(item.day)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(height: 200)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct AchievementsSection: View {
    let stats: (articlesRead: Int, questionsAnswered: Int, correctRate: Double)
    
    var achievements: [(title: String, description: String, isUnlocked: Bool, icon: String)] {
        [
            ("First Steps", "Read your first article", stats.articlesRead > 0, "book.fill"),
            ("Quiz Master", "Answer 10 questions", stats.questionsAnswered >= 10, "questionmark.circle.fill"),
            ("Accuracy Pro", "Achieve 80% accuracy", stats.correctRate >= 0.8, "target"),
            ("Knowledge Seeker", "Read 10 articles", stats.articlesRead >= 10, "books.vertical.fill"),
            ("Practice Makes Perfect", "Answer 50 questions", stats.questionsAnswered >= 50, "checkmark.seal.fill")
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Achievements")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(achievements, id: \.title) { achievement in
                        AchievementBadge(
                            title: achievement.title,
                            description: achievement.description,
                            isUnlocked: achievement.isUnlocked,
                            icon: achievement.icon
                        )
                    }
                }
            }
        }
    }
}

struct AchievementBadge: View {
    let title: String
    let description: String
    let isUnlocked: Bool
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(isUnlocked ? .yellow : .gray)
            
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 100, height: 120)
        .padding()
        .background(isUnlocked ? Color.yellow.opacity(0.1) : Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isUnlocked ? Color.yellow : Color.clear, lineWidth: 2)
        )
    }
}

struct StudyStreakCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundColor(.orange)
                
                Text("Study Streak")
                    .font(.headline)
                
                Spacer()
                
                Text("3 days")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            
            HStack(spacing: 4) {
                ForEach(0..<7) { day in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(day < 3 ? Color.orange : Color(.systemGray5))
                        .frame(height: 40)
                }
            }
            
            Text("Keep studying daily to maintain your streak!")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct BookmarkedItemsSection: View {
    @ObservedObject var service: StudyProtocolService
    
    var bookmarkedCount: Int {
        service.studyProgress.bookmarkedItems.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bookmark.fill")
                    .foregroundColor(.orange)
                
                Text("Bookmarked Items")
                    .font(.headline)
                
                Spacer()
                
                Text("\(bookmarkedCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
            }
            
            if bookmarkedCount > 0 {
                Text("You have \(bookmarkedCount) bookmarked items to review")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text("Bookmark articles and questions to review them later")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
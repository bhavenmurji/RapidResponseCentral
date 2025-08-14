import SwiftUI

// MARK: - Shimmer Effect Modifier
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    let animation = Animation.linear(duration: 1.5).repeatForever(autoreverses: false)
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0),
                        Color.white.opacity(0.4),
                        Color.white.opacity(0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase * 400 - 200)
                .mask(content)
            )
            .onAppear {
                withAnimation(animation) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}

// MARK: - Skeleton Category Card
struct SkeletonCategoryCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .shimmer()
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 40, height: 20)
                    .shimmer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 16)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 12)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 80, height: 12)
                    .shimmer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Skeleton Progress Card
struct SkeletonProgressCard: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 14)
                    .shimmer()
                
                Spacer()
            }
            
            HStack(spacing: 20) {
                ForEach(0..<3) { _ in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .shimmer()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.15))
                            .frame(width: 40, height: 10)
                            .shimmer()
                    }
                }
                Spacer()
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.05),
                    Color.purple.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
}

// MARK: - Loading State View
public struct StudyLoadingView: View {
    @State private var isAnimating = false
    
    public var body: some View {
        VStack(spacing: 20) {
            // Animated Logo
            Image(systemName: "books.vertical.fill")
                .font(.system(size: 48))
                .foregroundColor(.blue)
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .opacity(isAnimating ? 1 : 0.7)
                .animation(
                    Animation.easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            VStack(spacing: 8) {
                Text("Loading Study Resources")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Preparing your learning materials...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Progress Indicator
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.2)
        }
        .padding(40)
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Empty State View
public struct StudyEmptyStateView: View {
    let title: String
    let message: String
    let icon: String
    let action: (() -> Void)?
    
    public init(
        title: String = "No Content Available",
        message: String = "Check back later for new study materials",
        icon: String = "doc.text.magnifyingglass",
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            // Animated Icon
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 56))
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            if let action = action {
                Button(action: action) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .buttonStyle(PressedButtonStyle())
            }
        }
        .padding(40)
    }
}

// MARK: - Error State View
public struct StudyErrorStateView: View {
    let error: String
    let retry: () -> Void
    @State private var isAnimating = false
    
    public var body: some View {
        VStack(spacing: 24) {
            // Error Illustration
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 56))
                    .foregroundColor(.red)
                    .rotationEffect(.degrees(isAnimating ? -5 : 5))
                    .animation(
                        Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
            
            VStack(spacing: 12) {
                Text("Oops! Something went wrong")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(error)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            HStack(spacing: 16) {
                Button(action: retry) {
                    Label("Try Again", systemImage: "arrow.clockwise")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .buttonStyle(PressedButtonStyle())
                
                Button(action: {
                    // Report issue action
                }) {
                    Text("Report Issue")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }
                .buttonStyle(PressedButtonStyle())
            }
        }
        .padding(40)
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Pressed Button Style
struct PressedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Pull to Refresh Modifier
struct PullToRefresh: ViewModifier {
    @Binding var isRefreshing: Bool
    let action: () async -> Void
    
    func body(content: Content) -> some View {
        content
            .refreshable {
                isRefreshing = true
                await action()
                withAnimation {
                    isRefreshing = false
                }
            }
    }
}

extension View {
    func pullToRefresh(isRefreshing: Binding<Bool>, action: @escaping () async -> Void) -> some View {
        modifier(PullToRefresh(isRefreshing: isRefreshing, action: action))
    }
}

// MARK: - Success Animation View
public struct SuccessAnimationView: View {
    @State private var isAnimating = false
    @State private var checkmarkScale: CGFloat = 0
    
    public var body: some View {
        ZStack {
            Circle()
                .fill(Color.green.opacity(0.1))
                .frame(width: 100, height: 100)
                .scaleEffect(isAnimating ? 1.2 : 0)
                .opacity(isAnimating ? 1 : 0)
            
            Circle()
                .stroke(Color.green, lineWidth: 3)
                .frame(width: 80, height: 80)
                .scaleEffect(isAnimating ? 1 : 0)
                .opacity(isAnimating ? 1 : 0)
            
            Image(systemName: "checkmark")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.green)
                .scaleEffect(checkmarkScale)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                isAnimating = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    checkmarkScale = 1
                }
            }
        }
    }
}
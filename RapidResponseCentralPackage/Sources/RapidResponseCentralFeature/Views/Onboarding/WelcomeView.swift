import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct WelcomeView: View {
    @Binding var showingWelcome: Bool
    @State private var currentPage = 0
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                // Welcome Page
                WelcomePageView(
                    emoji: "🚨",
                    title: "RAPID RESPONSE CENTRAL",
                    subtitle: "Your comprehensive clinical decision support tool",
                    features: [
                        "Emergency protocols optimized for bedside use",
                        "Evidence-based calculators and tools",
                        "Virtua Voorhees-specific guidelines",
                        "Study tools for medical education"
                    ],
                    showButton: true,
                    buttonTitle: "Get Started",
                    buttonAction: { currentPage = 1 }
                )
                .tag(0)
                
                // Feature Tour Pages
                FeatureTourView(
                    emoji: "🚨",
                    title: "Emergency Protocols",
                    description: "Life-saving protocols like Code Blue, Stroke, and STEMI optimized for rapid access during critical situations.",
                    pageNumber: 1
                )
                .tag(1)
                
                FeatureTourView(
                    emoji: "⏱️",
                    title: "Real-Time Timer",
                    description: "Track protocol execution with integrated timer and automatic event logging for documentation.",
                    pageNumber: 2
                )
                .tag(2)
                
                FeatureTourView(
                    emoji: "📊",
                    title: "Medical Calculators",
                    description: "Essential clinical calculators like NIHSS, CHADS-VASc, and qSOFA at your fingertips.",
                    pageNumber: 3
                )
                .tag(3)
                
                FeatureTourView(
                    emoji: "💾",
                    title: "Offline First",
                    description: "All core protocols work offline. Your critical tools are always available when you need them.",
                    pageNumber: 4
                )
                .tag(4)
                
                // Privacy Notice
                PrivacyNoticeView(
                    onAccept: {
                        showingWelcome = false
                        UserDefaults.standard.set(true, forKey: "hasSeenWelcome")
                    }
                )
                .tag(5)
            }
            #if os(iOS)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            #endif
            
            // Skip button
            if currentPage < 5 {
                HStack {
                    Button("Skip") {
                        currentPage = 5
                    }
                    .foregroundColor(.secondary)
                    .padding()
                    
                    Spacer()
                    
                    Button("Next") {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                    .foregroundColor(.blue)
                    .padding()
                }
                .background(Color.white)
            }
        }
    }
}

struct WelcomePageView: View {
    let emoji: String
    let title: String
    let subtitle: String
    let features: [String]
    let showButton: Bool
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text(emoji)
                .font(.system(size: 80))
            
            VStack(spacing: 12) {
                Text("Welcome to")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(AppVersion.current.displayString)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            Text(subtitle)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(features, id: \.self) { feature in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text(feature)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            if showButton {
                Button(action: buttonAction) {
                    Text(buttonTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

struct FeatureTourView: View {
    let emoji: String
    let title: String
    let description: String
    let pageNumber: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text(emoji)
                .font(.system(size: 80))
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            Text("\(pageNumber) of 5")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 40)
        }
    }
}

struct PrivacyNoticeView: View {
    let onAccept: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("DATA PRIVACY NOTICE")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("This app is designed for clinical decision support only.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 12) {
                    PrivacyBulletPoint(text: "Do not enter patient identifiers")
                    PrivacyBulletPoint(text: "Event logs contain only protocol actions")
                    PrivacyBulletPoint(text: "No data is stored on external servers")
                    PrivacyBulletPoint(text: "All data remains on your device")
                }
                
                Text("For full privacy policy and HIPAA compliance information, visit: meddata.com/privacy")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: onAccept) {
                    Text("I Understand")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                
                Button(action: {}) {
                    Text("View Privacy Policy")
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

struct PrivacyBulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.body)
                .foregroundColor(.green)
            Text(text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    WelcomeView(showingWelcome: .constant(true))
}
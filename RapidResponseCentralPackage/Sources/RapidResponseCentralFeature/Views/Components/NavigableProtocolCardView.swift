import SwiftUI

// MARK: - Navigable Protocol Card View with Next/Previous Controls
public struct NavigableProtocolCardView: View {
    let card: ProtocolCard
    let isActive: Bool
    let currentNodeIndex: Int
    let totalNodes: Int
    let onPrevious: (() -> Void)?
    let onNext: (() -> Void)?
    
    public init(
        card: ProtocolCard,
        isActive: Bool = false,
        currentNodeIndex: Int = 0,
        totalNodes: Int = 0,
        onPrevious: (() -> Void)? = nil,
        onNext: (() -> Void)? = nil
    ) {
        self.card = card
        self.isActive = isActive
        self.currentNodeIndex = currentNodeIndex
        self.totalNodes = totalNodes
        self.onPrevious = onPrevious
        self.onNext = onNext
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Ultra-compact card header
            HStack(spacing: 4) {
                // Type icon
                Image(systemName: cardTypeIcon)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(cardTypeColor)
                
                Text(card.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Spacer()
                
                if isActive {
                    Text("ACTIVE")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(cardTypeColor)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(cardTypeColor.opacity(0.15))
            
            // Ultra-compact card content
            VStack(alignment: .leading, spacing: 4) {
                ForEach(card.sections, id: \.id) { section in
                    VStack(alignment: .leading, spacing: 2) {
                        if !section.title.isEmpty {
                            Text(section.title)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(cardTypeColor)
                                .padding(.bottom, 2)
                        }
                        
                        ForEach(section.items, id: \.self) { item in
                            HStack(alignment: .top, spacing: 4) {
                                // Bullet point
                                Circle()
                                    .fill(cardTypeColor.opacity(0.7))
                                    .frame(width: 3, height: 3)
                                    .offset(y: 4)
                                
                                Text(item)
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.primary.opacity(0.95))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.8)
                            }
                        }
                    }
                }
            }
            .padding(6)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Ultra-compact Navigation Controls
            if onPrevious != nil || onNext != nil {
                Divider()
                
                HStack(spacing: 6) {
                    // Previous button
                    Button(action: {
                        onPrevious?()
                    }) {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 9, weight: .semibold))
                            Text("Prev")
                                .font(.system(size: 9, weight: .medium))
                        }
                        .foregroundColor(currentNodeIndex > 0 ? cardTypeColor : .gray)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(currentNodeIndex > 0 ? cardTypeColor.opacity(0.1) : Color.gray.opacity(0.1))
                        )
                    }
                    .disabled(currentNodeIndex <= 0)
                    
                    Spacer()
                    
                    // Step indicator
                    Text("\(currentNodeIndex + 1)/\(totalNodes)")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Next button
                    Button(action: {
                        onNext?()
                    }) {
                        HStack(spacing: 2) {
                            Text("Next")
                                .font(.system(size: 9, weight: .medium))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 9, weight: .semibold))
                        }
                        .foregroundColor(currentNodeIndex < totalNodes - 1 ? cardTypeColor : .gray)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(currentNodeIndex < totalNodes - 1 ? cardTypeColor.opacity(0.1) : Color.gray.opacity(0.1))
                        )
                    }
                    .disabled(currentNodeIndex >= totalNodes - 1)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.secondarySystemBackground).opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity) // Ensure card uses full width
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .shadow(
                    color: isActive ? cardTypeColor.opacity(0.2) : .black.opacity(0.05),
                    radius: isActive ? 4 : 2,
                    y: 2
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isActive ? cardTypeColor : cardTypeColor.opacity(0.2),
                    lineWidth: isActive ? 2 : 0.5
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
    
    private var cardTypeColor: Color {
        switch card.type {
        case .dynamic: return .blue
        case .assessment: return .orange
        case .actions: return .green
        }
    }
    
    private var cardTypeIcon: String {
        switch card.type {
        case .dynamic: return "waveform.path.ecg"
        case .assessment: return "stethoscope"
        case .actions: return "cross.case"
        }
    }
}

#Preview {
    NavigableProtocolCardView(
        card: ProtocolCard(
            id: "test",
            type: .dynamic,
            title: "Initial Assessment",
            sections: [
                CardSection(
                    title: "Primary Survey",
                    items: [
                        "Check responsiveness",
                        "Open airway",
                        "Check breathing",
                        "Check circulation"
                    ]
                )
            ]
        ),
        isActive: true,
        currentNodeIndex: 2,
        totalNodes: 8,
        onPrevious: { print("Previous") },
        onNext: { print("Next") }
    )
    .padding()
}
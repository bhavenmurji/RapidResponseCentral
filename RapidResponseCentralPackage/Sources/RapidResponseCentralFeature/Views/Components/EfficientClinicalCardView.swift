import SwiftUI

// MARK: - Ultra-Efficient Clinical Card for Maximum Space Usage
public struct EfficientClinicalCardView: View {
    let card: ProtocolCard
    let isExpanded: Bool
    let onToggle: () -> Void
    
    public init(card: ProtocolCard, isExpanded: Bool, onToggle: @escaping () -> Void) {
        self.card = card
        self.isExpanded = isExpanded
        self.onToggle = onToggle
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Compact header button
            Button(action: onToggle) {
                HStack(spacing: 4) {
                    // Type indicator dot
                    Circle()
                        .fill(cardTypeColor)
                        .frame(width: 5, height: 5)
                    
                    Text(card.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(cardTypeColor.opacity(0.15))
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(card.sections, id: \.id) { section in
                        CompactSectionRow(section: section)
                    }
                }
                .padding(.all, 10)
                .background(Color(.systemBackground))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 3, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(cardTypeColor.opacity(0.4), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
    
    private var cardTypeColor: Color {
        switch card.type {
        case .dynamic: return .blue
        case .assessment: return .orange
        case .actions: return .green
        }
    }
}

// MARK: - Compact Section Row
struct CompactSectionRow: View {
    let section: CardSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !section.title.isEmpty {
                Text(section.title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 2)
            }
            
            ForEach(section.items, id: \.self) { item in
                HStack(alignment: .top, spacing: 6) {
                    Text("•")
                        .font(.system(size: 11))
                        .foregroundColor(Color.blue.opacity(0.7))
                    
                    Text(item)
                        .font(.system(size: 13))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                }
            }
        }
    }
}

#Preview {
    VStack {
        EfficientClinicalCardView(
            card: ProtocolCard(
                id: "test",
                type: .assessment,
                title: "Clinical Assessment",
                sections: [
                    CardSection(
                        title: "Vital Signs",
                        items: ["HR", "BP", "RR", "SpO2"]
                    ),
                    CardSection(
                        title: "Assessment",
                        items: ["Mental status", "Skin color", "Perfusion"]
                    )
                ]
            ),
            isExpanded: true,
            onToggle: {}
        )
        .frame(width: 180)
    }
    .padding()
}
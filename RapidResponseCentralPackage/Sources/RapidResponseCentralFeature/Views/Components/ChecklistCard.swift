import SwiftUI

// MARK: - Checklist Card for Protocol Setup
public struct ChecklistCard: View {
    let title: String
    let items: [ChecklistItem]
    let onComplete: () -> Void
    
    @State private var checkedItems: Set<String> = []
    @State private var allChecked = false
    
    public struct ChecklistItem: Identifiable {
        public let id = UUID().uuidString
        public let category: String
        public let title: String
        public let items: [String]
        
        public init(category: String, title: String, items: [String]) {
            self.category = category
            self.title = title
            self.items = items
        }
    }
    
    public init(title: String, items: [ChecklistItem], onComplete: @escaping () -> Void) {
        self.title = title
        self.items = items
        self.onComplete = onComplete
    }
    
    private var totalItemCount: Int {
        items.reduce(0) { $0 + $1.items.count }
    }
    
    private var isComplete: Bool {
        checkedItems.count == totalItemCount
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Ultra-compact Header
            HStack(spacing: 4) {
                Image(systemName: "checklist")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.blue)
                
                Text(title.uppercased())
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Progress indicator
                Text("\(checkedItems.count)/\(totalItemCount)")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(isComplete ? .green : .orange)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background(
                        Capsule()
                            .fill((isComplete ? Color.green : Color.orange).opacity(0.15))
                    )
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.08))
            
            // Ultra-compact non-scrolling content
            VStack(alignment: .leading, spacing: 3) {
                ForEach(items) { section in
                    VStack(alignment: .leading, spacing: 2) {
                        // Section header (minimal)
                        Text(section.category)
                            .font(.system(size: 7, weight: .bold))
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                        
                        // Checklist items (ultra-compact)
                        ForEach(section.items, id: \.self) { item in
                            HStack(spacing: 4) {
                                Button(action: {
                                    toggleItem(item)
                                }) {
                                    Image(systemName: checkedItems.contains(item) ? "checkmark.square.fill" : "square")
                                        .font(.system(size: 10))
                                        .foregroundColor(checkedItems.contains(item) ? .green : .gray)
                                }
                                .buttonStyle(.plain)
                                
                                Text(item)
                                    .font(.system(size: 8))
                                    .foregroundColor(.primary)
                                    .strikethrough(checkedItems.contains(item))
                                    .opacity(checkedItems.contains(item) ? 0.6 : 1.0)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleItem(item)
                            }
                        }
                    }
                    .padding(.horizontal, 6)
                    
                    if section.id != items.last?.id {
                        Divider()
                            .padding(.horizontal, 6)
                    }
                }
            }
            .padding(.vertical, 4)
            
            // Ultra-compact action buttons
            VStack(spacing: 2) {
                Divider()
                
                HStack(spacing: 6) {
                    // Check All button
                    Button(action: checkAll) {
                        HStack(spacing: 2) {
                            Image(systemName: "checkmark.rectangle.stack.fill")
                                .font(.system(size: 9))
                            Text("ALL")
                                .font(.system(size: 8, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.orange)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(isComplete)
                    .opacity(isComplete ? 0.5 : 1.0)
                    
                    Spacer()
                    
                    // Proceed button
                    Button(action: {
                        if isComplete {
                            onComplete()
                        }
                    }) {
                        HStack(spacing: 2) {
                            Text("PROCEED")
                                .font(.system(size: 9, weight: .bold))
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 10))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(isComplete ? Color.green : Color.gray)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(!isComplete)
                    .animation(.easeInOut(duration: 0.2), value: isComplete)
                }
                .padding(.horizontal, 6)
                .padding(.bottom, 4)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(color: Color.blue.opacity(0.15), radius: 4, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isComplete ? Color.green : Color.blue.opacity(0.3), lineWidth: isComplete ? 2 : 1)
        )
        .animation(.easeInOut(duration: 0.3), value: isComplete)
    }
    
    private func toggleItem(_ item: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if checkedItems.contains(item) {
                checkedItems.remove(item)
            } else {
                checkedItems.insert(item)
            }
        }
    }
    
    private func checkAll() {
        withAnimation(.easeInOut(duration: 0.3)) {
            for section in items {
                for item in section.items {
                    checkedItems.insert(item)
                }
            }
        }
    }
}

// MARK: - Code Blue Initial Checklist
public struct CodeBlueInitialChecklist: View {
    let onComplete: () -> Void
    
    public init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }
    
    private let checklistItems = [
        ChecklistCard.ChecklistItem(
            category: "CPR",
            title: "Initial",
            items: [
                "CPR 100-120/min",
                "Airway secure",
                "Pads on",
                "Monitor on"
            ]
        ),
        ChecklistCard.ChecklistItem(
            category: "TEAM",
            title: "Roles",
            items: [
                "Lead/Coach",
                "Airway",
                "Meds/Defib",
                "Recorder"
            ]
        ),
        ChecklistCard.ChecklistItem(
            category: "SETUP",
            title: "Scene",
            items: [
                "Rotation plan",
                "Family contact",
                "Runners ready"
            ]
        )
    ]
    
    public var body: some View {
        ChecklistCard(
            title: "CODE BLUE SETUP CHECKLIST",
            items: checklistItems,
            onComplete: onComplete
        )
    }
}

#Preview {
    VStack {
        CodeBlueInitialChecklist(onComplete: {
            print("Checklist complete!")
        })
        .frame(width: 350)
        .padding()
    }
    .background(Color(.systemBackground))
}
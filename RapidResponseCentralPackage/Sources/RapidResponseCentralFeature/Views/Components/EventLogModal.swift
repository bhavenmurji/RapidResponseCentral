import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct EventLogModal: View {
    let session: ProtocolSession
    @Environment(\.dismiss) private var dismiss
    @State private var showingExportOptions = false
    @State private var showingClearConfirmation = false
    @State private var editingEvent: EventLogEntry?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header Info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Protocol:")
                        Text(session.protocolTitle)
                            .fontWeight(.medium)
                        if let location = session.location {
                            Text("- \(location)")
                                .foregroundColor(.secondary)
                        }
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Text("Duration:")
                        Text(session.formattedDuration)
                            .fontWeight(.medium)
                        Text(session.isActive ? "(Active)" : "(Completed)")
                            .foregroundColor(session.isActive ? .green : .secondary)
                    }
                    .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.2))
                
                // Event List
                if session.events.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "list.bullet.rectangle")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text("No events logged yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(session.events) { event in
                            EventRow(event: event)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        deleteEvent(event)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                    Button {
                                        editingEvent = event
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.orange)
                                }
                        }
                    }
                    .listStyle(.plain)
                }
                
                // Bottom Actions
                HStack(spacing: 16) {
                    Button(action: { showingExportOptions = true }) {
                        Label("Export Log", systemImage: "square.and.arrow.up")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: { showingClearConfirmation = true }) {
                        Label("Clear All", systemImage: "trash")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .foregroundColor(.red)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("EVENT LOG")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .confirmationDialog("Export Event Log", isPresented: $showingExportOptions) {
            Button("Export as Text") {
                exportAsText()
            }
            Button("Export to Files") {
                exportToFiles()
            }
            Button("Share") {
                shareLog()
            }
        }
        .alert("Clear All Events?", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Clear All", role: .destructive) {
                clearAllEvents()
            }
        } message: {
            Text("This action cannot be undone. Delete all \(session.events.count) logged events?")
        }
        .sheet(item: $editingEvent) { event in
            EditEventView(event: event, session: session)
        }
    }
    
    private func deleteEvent(_ event: EventLogEntry) {
        withAnimation {
            session.events.removeAll { $0.id == event.id }
        }
    }
    
    private func clearAllEvents() {
        withAnimation {
            session.events.removeAll()
        }
    }
    
    private func exportAsText() {
        let export = EventLogExport(session: session)
        let text = export.exportAsText()
        // TODO: Save to clipboard or file
        print(text)
    }
    
    private func exportToFiles() {
        // TODO: Implement file export
    }
    
    private func shareLog() {
        // TODO: Implement sharing
    }
}

struct EventRow: View {
    let event: EventLogEntry
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Time
            Text(event.formattedTime)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)
            
            // Icon and Description
            HStack(alignment: .top, spacing: 8) {
                if !event.type.icon.isEmpty {
                    Text(event.type.icon)
                        .font(.body)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.description)
                        .font(.body)
                    
                    if let notes = event.additionalNotes {
                        Text(notes)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct EditEventView: View {
    let event: EventLogEntry
    let session: ProtocolSession
    @Environment(\.dismiss) private var dismiss
    @State private var description: String = ""
    @State private var notes: String = ""
    @State private var selectedType: EventLogEntry.EventType = .customNote
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Event Details") {
                    HStack {
                        Text("Time:")
                        Text(event.formattedTime)
                            .foregroundColor(.secondary)
                    }
                    
                    Picker("Event Type", selection: $selectedType) {
                        Text("Medication").tag(EventLogEntry.EventType.medication)
                        Text("Procedure").tag(EventLogEntry.EventType.checkboxAction)
                        Text("Phone Call").tag(EventLogEntry.EventType.phoneCall)
                        Text("Note").tag(EventLogEntry.EventType.customNote)
                    }
                    
                    TextField("Description", text: $description)
                    
                    TextField("Additional Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("EDIT EVENT")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .automatic) {
                    Button("Save") {
                        // TODO: Update event
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            description = event.description
            notes = event.additionalNotes ?? ""
            selectedType = event.type
        }
    }
}

#Preview {
    EventLogModal(
        session: {
            let session = ProtocolSession(
                protocolId: "code-blue",
                protocolTitle: "Code Blue",
                location: "Room 214"
            )
            session.addEvent(EventLogEntry(
                relativeTime: 0,
                type: .protocolStart,
                description: "Code Blue initiated"
            ))
            session.addEvent(EventLogEntry(
                relativeTime: 45,
                type: .checkboxAction,
                description: "Shock delivered - 200J"
            ))
            session.addEvent(EventLogEntry(
                relativeTime: 90,
                type: .lapMarker,
                description: "Lap"
            ))
            return session
        }()
    )
}
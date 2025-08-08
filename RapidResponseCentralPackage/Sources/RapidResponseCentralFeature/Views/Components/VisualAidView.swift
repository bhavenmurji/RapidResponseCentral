import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Visual Aid View Component
// Purpose: Display educational images with annotations and interactive elements
// Features: Responsive sizing, annotation overlay, accessibility support

struct VisualAidView: View {
    let visualAid: VisualAid
    let sizing: ContentSizing
    @State private var showingFullScreen = false
    @State private var selectedAnnotation: EducationalAnnotation?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title and description
            if !visualAid.title.isEmpty {
                HStack {
                    Image(systemName: "photo.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(visualAid.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if visualAid.interactionType != .none {
                        Button(action: { showingFullScreen = true }) {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            
            // Main image with annotations
            ZStack {
                AsyncImage(url: Bundle.main.url(forResource: visualAid.imageName, withExtension: nil)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                        
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Text("Loading...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .overlay(
                    AnnotationOverlayView(
                        annotations: visualAid.annotations,
                        selectedAnnotation: $selectedAnnotation
                    )
                )
            }
            .frame(
                minHeight: sizing.minHeight,
                maxHeight: sizing.maxHeight
            )
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
            .onTapGesture {
                if visualAid.interactionType == .tap {
                    showingFullScreen = true
                }
            }
            
            // Image description
            if let description = visualAid.description, !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Selected annotation details
            if let annotation = selectedAnnotation {
                AnnotationDetailView(annotation: annotation)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .animation(.easeInOut(duration: 0.3), value: selectedAnnotation)
            }
        }
        #if os(iOS)
        .fullScreenCover(isPresented: $showingFullScreen) {
            FullScreenVisualAidView(
                visualAid: visualAid,
                selectedAnnotation: $selectedAnnotation
            )
        }
        #else
        .sheet(isPresented: $showingFullScreen) {
            FullScreenVisualAidView(
                visualAid: visualAid,
                selectedAnnotation: $selectedAnnotation
            )
        }
        #endif
    }
}

// MARK: - Annotation Overlay

struct AnnotationOverlayView: View {
    let annotations: [EducationalAnnotation]
    @Binding var selectedAnnotation: EducationalAnnotation?
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(annotations) { annotation in
                AnnotationMarkerView(
                    annotation: annotation,
                    isSelected: selectedAnnotation?.id == annotation.id
                )
                .position(
                    x: geometry.size.width * annotation.position.x,
                    y: geometry.size.height * annotation.position.y
                )
                .onTapGesture {
                    if selectedAnnotation?.id == annotation.id {
                        selectedAnnotation = nil
                    } else {
                        selectedAnnotation = annotation
                    }
                }
            }
        }
    }
}

// MARK: - Annotation Marker

struct AnnotationMarkerView: View {
    let annotation: EducationalAnnotation
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(annotation.color.color)
                .frame(width: isSelected ? 24 : 16, height: isSelected ? 24 : 16)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
            
            if isSelected {
                Circle()
                    .stroke(annotation.color.color, lineWidth: 2)
                    .frame(width: 32, height: 32)
                    .scaleEffect(isSelected ? 1.0 : 0.8)
                    .opacity(isSelected ? 0.6 : 0.0)
            }
        }
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

// MARK: - Annotation Detail View

struct AnnotationDetailView: View {
    let annotation: EducationalAnnotation
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(annotation.color.color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(annotation.label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(annotation.type.rawValue)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
        )
    }
}

// MARK: - Full Screen Visual Aid View

struct FullScreenVisualAidView: View {
    let visualAid: VisualAid
    @Binding var selectedAnnotation: EducationalAnnotation?
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView([.horizontal, .vertical]) {
                    ZStack {
                        AsyncImage(url: Bundle.main.url(forResource: visualAid.imageName, withExtension: nil)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                                .tint(.white)
                        }
                        .overlay(
                            AnnotationOverlayView(
                                annotations: visualAid.annotations,
                                selectedAnnotation: $selectedAnnotation
                            )
                        )
                    }
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        SimultaneousGesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = max(1.0, min(3.0, value))
                                },
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation
                                }
                        )
                    )
                }
                
                // Annotation detail overlay
                if let annotation = selectedAnnotation {
                    VStack {
                        Spacer()
                        
                        AnnotationDetailView(annotation: annotation)
                            .padding(.horizontal)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                                    .shadow(radius: 10)
                            )
                            .padding()
                    }
                }
            }
            .navigationTitle(visualAid.title)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar(content: {
                ToolbarItem(placement: .automatic) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            })
        }
    }
}

// MARK: - Rhythm Recognition Specialized View

struct RhythmRecognitionView: View {
    let educationalContent: EducationalContent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: educationalContent.contentType.icon)
                    .foregroundColor(educationalContent.contentType.color)
                
                Text(educationalContent.title)
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
            }
            
            // Description
            if let description = educationalContent.description {
                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            // Visual aids
            ForEach(educationalContent.visualAids) { visualAid in
                VisualAidView(
                    visualAid: visualAid,
                    sizing: .rhythmChart
                )
            }
            
            // Key points for rhythm recognition
            if !educationalContent.keyPoints.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Key Recognition Points")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    ForEach(educationalContent.keyPoints) { keyPoint in
                        KeyPointView(keyPoint: keyPoint)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

// MARK: - Key Point View

struct KeyPointView: View {
    let keyPoint: KeyPoint
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: keyPoint.importance.icon)
                .font(.caption)
                .foregroundColor(keyPoint.importance.color)
                .frame(width: 16)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(keyPoint.text)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(keyPoint.description)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(keyPoint.importance.color.opacity(0.1))
        )
    }
}

#Preview {
    VStack {
        VisualAidView(
            visualAid: VisualAid(
                id: "rhythm-chart",
                imageName: "Shockablevsnonshockable.jpg",
                title: "Shockable vs Non-Shockable Rhythms",
                description: "Visual guide for identifying shockable and non-shockable cardiac rhythms",
                annotations: [
                    EducationalAnnotation(
                        id: "vfib",
                        label: "V-Fib",
                        description: "Ventricular Fibrillation - Shockable",
                        position: AnnotationPosition(x: 0.25, y: 0.3),
                        type: .callout,
                        color: .success
                    ),
                    EducationalAnnotation(
                        id: "asystole",
                        label: "Asystole",
                        description: "Asystole - Non-Shockable",
                        position: AnnotationPosition(x: 0.75, y: 0.3),
                        type: .callout,
                        color: .danger
                    )
                ],
                layout: .aspectRatio,
                interactionType: .tap
            ),
            sizing: .rhythmChart
        )
        
        Spacer()
    }
    .padding()
}
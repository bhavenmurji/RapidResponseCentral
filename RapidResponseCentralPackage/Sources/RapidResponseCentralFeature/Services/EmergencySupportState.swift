import SwiftUI

// MARK: - Shared State Manager for Emergency Support Card
@MainActor
public class EmergencySupportState: ObservableObject {
    @Published public var currentPage: Int = 0
    
    public static let shared = EmergencySupportState()
    
    private init() {}
    
    public func setPage(_ page: Int) {
        currentPage = page
    }
}
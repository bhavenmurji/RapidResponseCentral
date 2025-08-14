import Testing
@testable import RapidResponseCentralFeature

/// Integration tests for ProtocolService
/// This service orchestrates all protocol services and provides unified access
@MainActor
struct ProtocolServiceTests {
    
    // MARK: - Service Initialization Tests
    
    @Test func testProtocolServiceInitialization() async throws {
        let service = ProtocolService()
        
        #expect(service.protocols.count > 0, "Emergency protocols should be loaded")
        #expect(service.rrtProtocols.count > 0, "RRT protocols should be loaded")
        #expect(service.isLoading == false, "Loading should complete during initialization")
        #expect(service.error == nil, "No errors should occur during initialization")
    }
    
    @Test func testProtocolServiceLoadsBothServices() async throws {
        let service = ProtocolService()
        
        // Verify emergency protocols
        let emergencyProtocolIds = service.protocols.map { $0.id }
        #expect(emergencyProtocolIds.contains("code_blue"))
        #expect(emergencyProtocolIds.contains("code_stroke"))
        #expect(emergencyProtocolIds.contains("anaphylaxis_protocol"))
        
        // Verify RRT protocols
        let rrtProtocolIds = service.rrtProtocols.map { $0.id }
        #expect(rrtProtocolIds.contains("rrt_sepsis"))
        #expect(rrtProtocolIds.contains("rrt_respiratory_distress"))
        #expect(rrtProtocolIds.contains("rrt_hypotension"))
    }
    
    // MARK: - Protocol Lookup Tests
    
    @Test func testGetProtocolById() async throws {
        let service = ProtocolService()
        
        // Test emergency protocol lookup
        let codeBlue = service.getProtocol(for: "code_blue")
        #expect(codeBlue != nil)
        #expect(codeBlue?.title == "Code Blue - ACLS")
        #expect(codeBlue?.category == .cardiac)
        
        // Test RRT protocol lookup
        let sepsis = service.getProtocol(for: "rrt_sepsis")
        #expect(sepsis != nil)
        #expect(sepsis?.title == "Sepsis Recognition & Management")
        #expect(sepsis?.category == .infectious)
        
        // Test non-existent protocol
        let nonExistent = service.getProtocol(for: "non_existent_protocol")
        #expect(nonExistent == nil)
    }
    
    @Test func testGetProtocolByTitle() async throws {
        let service = ProtocolService()
        
        // Test emergency protocol lookup by title
        let codeStroke = service.getProtocol(by: "Code Stroke")
        #expect(codeStroke != nil)
        #expect(codeStroke?.id == "code_stroke")
        #expect(codeStroke?.category == .neurological)
        
        // Test RRT protocol lookup by title
        let respiratoryDistress = service.getProtocol(by: "Respiratory Distress Management")
        #expect(respiratoryDistress != nil)
        #expect(respiratoryDistress?.id == "rrt_respiratory_distress")
        
        // Test case-insensitive search (if supported)
        let anaphylaxis = service.getProtocol(by: "anaphylaxis management")
        // This might be nil if case-insensitive search is not implemented
        if anaphylaxis != nil {
            #expect(anaphylaxis?.id == "anaphylaxis_protocol")
        }
        
        // Test non-existent protocol by title
        let nonExistent = service.getProtocol(by: "Non-Existent Protocol")
        #expect(nonExistent == nil)
    }
    
    @Test func testGetRRTProtocolSpecifically() async throws {
        let service = ProtocolService()
        
        // Test specific RRT protocol lookup
        let neurologicalAssessment = service.getRRTProtocol(for: "rrt_neurological_assessment")
        #expect(neurologicalAssessment != nil)
        #expect(neurologicalAssessment?.title == "Neurological Assessment & Management")
        
        // Test that emergency protocols are not returned by RRT lookup
        let codeBlue = service.getRRTProtocol(for: "code_blue")
        #expect(codeBlue == nil, "Emergency protocols should not be returned by RRT lookup")
        
        // Test non-existent RRT protocol
        let nonExistent = service.getRRTProtocol(for: "non_existent_rrt")
        #expect(nonExistent == nil)
    }
    
    @Test func testGetAllProtocols() async throws {
        let service = ProtocolService()
        
        let allProtocols = service.getAllProtocols()
        let emergencyCount = service.protocols.count
        let rrtCount = service.rrtProtocols.count
        
        #expect(allProtocols.count == emergencyCount + rrtCount)
        
        // Verify all protocols are included
        let allIds = Set(allProtocols.map { $0.id })
        let emergencyIds = Set(service.protocols.map { $0.id })
        let rrtIds = Set(service.rrtProtocols.map { $0.id })
        
        #expect(allIds.isSuperset(of: emergencyIds))
        #expect(allIds.isSuperset(of: rrtIds))
        #expect(allIds.count == emergencyIds.count + rrtIds.count, "No duplicate protocol IDs")
    }
    
    // MARK: - Protocol Uniqueness Tests
    
    @Test func testProtocolIdsAreUnique() async throws {
        let service = ProtocolService()
        
        let allProtocols = service.getAllProtocols()
        let allIds = allProtocols.map { $0.id }
        let uniqueIds = Set(allIds)
        
        #expect(allIds.count == uniqueIds.count, "All protocol IDs must be unique across both services")
        
        // Verify emergency and RRT protocols don't have overlapping IDs
        let emergencyIds = Set(service.protocols.map { $0.id })
        let rrtIds = Set(service.rrtProtocols.map { $0.id })
        
        #expect(emergencyIds.intersection(rrtIds).isEmpty, "Emergency and RRT protocols must have distinct IDs")
    }
    
    @Test func testProtocolTitlesAreDescriptive() async throws {
        let service = ProtocolService()
        
        let allProtocols = service.getAllProtocols()
        
        for protocol in allProtocols {
            #expect(!protocol.title.isEmpty, "Protocol '\(protocol.id)' must have a title")
            #expect(protocol.title.count > 3, "Protocol title should be descriptive: '\(protocol.title)'")
            #expect(!protocol.title.contains("test"), "Protocol title should not contain 'test': '\(protocol.title)'")
        }
    }
    
    // MARK: - Protocol Categories Distribution Tests
    
    @Test func testProtocolCategoriesAreProperlyCovered() async throws {
        let service = ProtocolService()
        
        let allProtocols = service.getAllProtocols()
        let categories = allProtocols.map { $0.category }
        let uniqueCategories = Set(categories)
        
        // Verify we have good coverage across categories
        #expect(uniqueCategories.contains(.cardiac), "Should have cardiac protocols")
        #expect(uniqueCategories.contains(.neurological), "Should have neurological protocols")
        #expect(uniqueCategories.contains(.respiratory), "Should have respiratory protocols")
        #expect(uniqueCategories.contains(.infectious), "Should have infectious disease protocols")
        #expect(uniqueCategories.contains(.allergic), "Should have allergy/anaphylaxis protocols")
        
        // Count protocols per category
        let cardiacCount = categories.filter { $0 == .cardiac }.count
        let neurologicalCount = categories.filter { $0 == .neurological }.count
        let respiratoryCount = categories.filter { $0 == .respiratory }.count
        
        #expect(cardiacCount > 0, "Should have at least one cardiac protocol")
        #expect(neurologicalCount > 0, "Should have at least one neurological protocol")
        #expect(respiratoryCount > 0, "Should have at least one respiratory protocol")
    }
    
    // MARK: - Service Refresh Tests
    
    @Test func testRefreshProtocols() async throws {
        let service = ProtocolService()
        
        let initialEmergencyCount = service.protocols.count
        let initialRRTCount = service.rrtProtocols.count
        
        // Refresh protocols
        service.refreshProtocols()
        
        // Verify protocols are still loaded after refresh
        #expect(service.protocols.count == initialEmergencyCount, "Emergency protocols should remain consistent after refresh")
        #expect(service.rrtProtocols.count == initialRRTCount, "RRT protocols should remain consistent after refresh")
        #expect(service.isLoading == false, "Loading should complete after refresh")
        #expect(service.error == nil, "No errors should occur during refresh")
    }
    
    // MARK: - Performance Tests
    
    @Test func testProtocolLookupPerformance() async throws {
        let service = ProtocolService()
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Perform multiple lookups
        for _ in 0..<1000 {
            _ = service.getProtocol(for: "code_blue")
            _ = service.getProtocol(for: "rrt_sepsis")
            _ = service.getProtocol(by: "Code Stroke")
            _ = service.getRRTProtocol(for: "rrt_hypotension")
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let lookupTime = endTime - startTime
        
        #expect(lookupTime < 1.0, "Protocol lookups should be very fast: \(lookupTime)s")
    }
    
    @Test func testGetAllProtocolsPerformance() async throws {
        let service = ProtocolService()
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Call getAllProtocols multiple times
        for _ in 0..<100 {
            let allProtocols = service.getAllProtocols()
            #expect(allProtocols.count > 0)
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let getAllTime = endTime - startTime
        
        #expect(getAllTime < 0.5, "getAllProtocols should be fast: \(getAllTime)s")
    }
    
    // MARK: - Data Consistency Tests
    
    @Test func testProtocolDataConsistency() async throws {
        let service = ProtocolService()
        
        // Verify protocols from individual services match those from ProtocolService
        let directEmergencyService = EmergencyProtocolService()
        let directRRTService = RRTProtocolService()
        
        #expect(service.protocols.count == directEmergencyService.protocols.count,
               "Emergency protocol count should match direct service")
        #expect(service.rrtProtocols.count == directRRTService.protocols.count,
               "RRT protocol count should match direct service")
        
        // Verify protocol IDs match
        let serviceEmergencyIds = Set(service.protocols.map { $0.id })
        let directEmergencyIds = Set(directEmergencyService.protocols.map { $0.id })
        #expect(serviceEmergencyIds == directEmergencyIds, "Emergency protocol IDs should match")
        
        let serviceRRTIds = Set(service.rrtProtocols.map { $0.id })
        let directRRTIds = Set(directRRTService.protocols.map { $0.id })
        #expect(serviceRRTIds == directRRTIds, "RRT protocol IDs should match")
    }
    
    @Test func testProtocolContentIntegrity() async throws {
        let service = ProtocolService()
        
        let allProtocols = service.getAllProtocols()
        
        for protocol in allProtocols {
            // Verify essential protocol components
            #expect(!protocol.id.isEmpty, "Protocol ID cannot be empty")
            #expect(!protocol.title.isEmpty, "Protocol title cannot be empty")
            #expect(!protocol.icon.isEmpty, "Protocol icon cannot be empty")
            #expect(protocol.algorithm.nodes.count > 0, "Protocol must have algorithm nodes")
            #expect(protocol.cards.count > 0, "Protocol must have information cards")
            
            // Verify algorithm node integrity
            for node in protocol.algorithm.nodes {
                #expect(!node.id.isEmpty, "Algorithm node ID cannot be empty")
                #expect(!node.title.isEmpty, "Algorithm node title cannot be empty")
                #expect(!node.content.isEmpty, "Algorithm node content cannot be empty")
            }
            
            // Verify card integrity
            for card in protocol.cards {
                #expect(!card.id.isEmpty, "Protocol card ID cannot be empty")
                #expect(!card.title.isEmpty, "Protocol card title cannot be empty")
                #expect(card.sections.count > 0, "Protocol card must have sections")
                
                for section in card.sections {
                    #expect(!section.title.isEmpty, "Card section title cannot be empty")
                    #expect(section.items.count > 0, "Card section must have items")
                    
                    for item in section.items {
                        #expect(!item.isEmpty, "Card section item cannot be empty")
                    }
                }
            }
        }
    }
    
    // MARK: - Critical Protocol Availability Tests
    
    @Test func testCriticalEmergencyProtocolsAreAvailable() async throws {
        let service = ProtocolService()
        
        // These protocols are essential for emergency medicine
        let criticalProtocols = [
            "code_blue",           // Cardiac arrest
            "code_stroke",         // Stroke management
            "code_stemi",          // Heart attack
            "anaphylaxis_protocol", // Severe allergic reactions
            "rsi_protocol"         // Airway management
        ]
        
        for protocolId in criticalProtocols {
            let protocol = service.getProtocol(for: protocolId)
            #expect(protocol != nil, "Critical protocol '\(protocolId)' must be available")
            
            if let protocol = protocol {
                // Verify critical protocols have critical nodes
                let criticalNodes = protocol.algorithm.nodes.filter { $0.critical }
                #expect(criticalNodes.count > 0, "Critical protocol '\(protocolId)' must have critical algorithm nodes")
            }
        }
    }
    
    @Test func testCriticalRRTProtocolsAreAvailable() async throws {
        let service = ProtocolService()
        
        // These RRT protocols are essential for preventing deterioration
        let criticalRRTProtocols = [
            "rrt_sepsis",                    // Infection management
            "rrt_respiratory_distress",      // Breathing problems
            "rrt_hypotension",              // Blood pressure management
            "rrt_neurological_assessment",   // Neurological changes
            "rrt_rapid_deterioration"       // General deterioration
        ]
        
        for protocolId in criticalRRTProtocols {
            let protocol = service.getRRTProtocol(for: protocolId)
            #expect(protocol != nil, "Critical RRT protocol '\(protocolId)' must be available")
            
            if let protocol = protocol {
                #expect(protocol.algorithm.nodes.count > 0, "RRT protocol '\(protocolId)' must have algorithm")
                #expect(protocol.cards.count > 0, "RRT protocol '\(protocolId)' must have information cards")
            }
        }
    }
    
    // MARK: - Search and Filter Simulation Tests
    
    @Test func testProtocolSearchSimulation() async throws {
        let service = ProtocolService()
        
        let allProtocols = service.getAllProtocols()
        
        // Simulate search for "cardiac" protocols
        let cardiacProtocols = allProtocols.filter { 
            $0.title.localizedCaseInsensitiveContains("cardiac") || 
            $0.category == .cardiac ||
            $0.title.localizedCaseInsensitiveContains("heart") ||
            $0.title.localizedCaseInsensitiveContains("stemi") ||
            $0.title.localizedCaseInsensitiveContains("code blue")
        }
        
        #expect(cardiacProtocols.count > 0, "Should find cardiac-related protocols")
        
        // Simulate search for "respiratory" protocols
        let respiratoryProtocols = allProtocols.filter {
            $0.title.localizedCaseInsensitiveContains("respiratory") ||
            $0.category == .respiratory ||
            $0.title.localizedCaseInsensitiveContains("breathing") ||
            $0.title.localizedCaseInsensitiveContains("airway") ||
            $0.title.localizedCaseInsensitiveContains("rsi")
        }
        
        #expect(respiratoryProtocols.count > 0, "Should find respiratory-related protocols")
        
        // Simulate search for "sepsis"
        let sepsisProtocols = allProtocols.filter {
            $0.title.localizedCaseInsensitiveContains("sepsis") ||
            $0.id.contains("sepsis")
        }
        
        #expect(sepsisProtocols.count > 0, "Should find sepsis protocols")
    }
    
    // MARK: - Error Resilience Tests
    
    @Test func testServiceResilienceToInvalidInput() async throws {
        let service = ProtocolService()
        
        // Test empty string inputs
        #expect(service.getProtocol(for: "") == nil)
        #expect(service.getProtocol(by: "") == nil)
        #expect(service.getRRTProtocol(for: "") == nil)
        
        // Test whitespace inputs
        #expect(service.getProtocol(for: "   ") == nil)
        #expect(service.getProtocol(by: "   ") == nil)
        #expect(service.getRRTProtocol(for: "   ") == nil)
        
        // Test special characters
        #expect(service.getProtocol(for: "!@#$%") == nil)
        #expect(service.getProtocol(by: "!@#$%") == nil)
        #expect(service.getRRTProtocol(for: "!@#$%") == nil)
        
        // Test very long strings
        let longString = String(repeating: "a", count: 1000)
        #expect(service.getProtocol(for: longString) == nil)
        #expect(service.getProtocol(by: longString) == nil)
        #expect(service.getRRTProtocol(for: longString) == nil)
    }
    
    // MARK: - Memory Management Tests
    
    @Test func testServiceMemoryEfficiency() async throws {
        var services: [ProtocolService] = []
        
        // Create multiple service instances
        for _ in 0..<5 {
            services.append(ProtocolService())
        }
        
        // Verify all instances work correctly
        for (index, service) in services.enumerated() {
            #expect(service.protocols.count > 0, "Service \(index) should have emergency protocols")
            #expect(service.rrtProtocols.count > 0, "Service \(index) should have RRT protocols")
            
            let codeBlue = service.getProtocol(for: "code_blue")
            #expect(codeBlue != nil, "Service \(index) should find Code Blue protocol")
        }
        
        // Clear all references
        services.removeAll()
        
        // Create a new service to ensure no issues
        let newService = ProtocolService()
        #expect(newService.protocols.count > 0, "New service should work after clearing others")
    }
}
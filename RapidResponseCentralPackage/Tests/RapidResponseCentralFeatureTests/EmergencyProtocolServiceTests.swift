import Testing
@testable import RapidResponseCentralFeature

/// Critical test suite for EmergencyProtocolService
/// This service provides life-saving emergency protocols
@MainActor
struct EmergencyProtocolServiceTests {
    
    // MARK: - Service Initialization Tests
    
    @Test func testServiceInitialization() async throws {
        let service = EmergencyProtocolService()
        
        #expect(service.protocols.count > 0)
        #expect(service.isLoading == false) // Should complete loading during init
    }
    
    @Test func testProtocolsLoadedCorrectly() async throws {
        let service = EmergencyProtocolService()
        
        // Verify expected protocols are present
        let protocolIds = service.protocols.map { $0.id }
        
        #expect(protocolIds.contains("code_blue"))
        #expect(protocolIds.contains("code_stroke"))
        #expect(protocolIds.contains("code_stemi"))
        #expect(protocolIds.contains("rsi_protocol"))
        #expect(protocolIds.contains("shock_protocol"))
        #expect(protocolIds.contains("anaphylaxis_protocol"))
        #expect(protocolIds.contains("emergency_support"))
    }
    
    // MARK: - Code Blue Protocol Tests (CRITICAL)
    
    @Test func testCodeBlueProtocolStructure() async throws {
        let service = EmergencyProtocolService()
        let codeBlueProtocol = service.protocols.first { $0.id == "code_blue" }
        
        #expect(codeBlueProtocol != nil)
        guard let protocol = codeBlueProtocol else { return }
        
        #expect(protocol.title == "Code Blue - ACLS")
        #expect(protocol.category == .cardiac)
        #expect(protocol.icon == "bx-heart-pulse")
        #expect(protocol.algorithm.nodes.count > 0)
        #expect(protocol.cards.count == 3) // Dynamic, Assessment, Actions
    }
    
    @Test func testCodeBlueAlgorithmCriticalPath() async throws {
        let service = EmergencyProtocolService()
        let codeBlueProtocol = service.protocols.first { $0.id == "code_blue" }
        
        guard let protocol = codeBlueProtocol else {
            Issue.record("Code Blue protocol not found")
            return
        }
        
        let criticalNodes = protocol.algorithm.nodes.filter { $0.critical }
        let nodeIds = criticalNodes.map { $0.id }
        
        // Verify critical nodes are present
        #expect(nodeIds.contains("initial_assessment"))
        #expect(nodeIds.contains("cpr_check"))
        #expect(nodeIds.contains("start_cpr"))
        #expect(nodeIds.contains("rhythm_check"))
        #expect(nodeIds.contains("epinephrine"))
    }
    
    @Test func testCodeBlueEpinephrineDosing() async throws {
        let service = EmergencyProtocolService()
        let codeBlueProtocol = service.protocols.first { $0.id == "code_blue" }
        
        guard let protocol = codeBlueProtocol else {
            Issue.record("Code Blue protocol not found")
            return
        }
        
        let epinephrineNode = protocol.algorithm.nodes.first { $0.id == "epinephrine" }
        
        #expect(epinephrineNode != nil)
        #expect(epinephrineNode?.critical == true)
        #expect(epinephrineNode?.nodeType == .medication)
        #expect(epinephrineNode?.content.contains("1mg"))
        #expect(epinephrineNode?.content.contains("3-5 minutes"))
    }
    
    // MARK: - Code Stroke Protocol Tests (CRITICAL)
    
    @Test func testCodeStrokeProtocolStructure() async throws {
        let service = EmergencyProtocolService()
        let strokeProtocol = service.protocols.first { $0.id == "code_stroke" }
        
        #expect(strokeProtocol != nil)
        guard let protocol = strokeProtocol else { return }
        
        #expect(protocol.title == "Code Stroke")
        #expect(protocol.category == .neurological)
        #expect(protocol.icon == "bx-brain")
        #expect(protocol.algorithm.nodes.count > 0)
        #expect(protocol.cards.count == 3)
    }
    
    @Test func testCodeStrokeTimeWindows() async throws {
        let service = EmergencyProtocolService()
        let strokeProtocol = service.protocols.first { $0.id == "code_stroke" }
        
        guard let protocol = strokeProtocol else {
            Issue.record("Code Stroke protocol not found")
            return
        }
        
        let timeWindowNode = protocol.algorithm.nodes.first { $0.id == "time_window" }
        
        #expect(timeWindowNode != nil)
        #expect(timeWindowNode?.critical == true)
        #expect(timeWindowNode?.content.contains("4.5 hours"))
    }
    
    @Test func testCodeStrokeTNKDosing() async throws {
        let service = EmergencyProtocolService()
        let strokeProtocol = service.protocols.first { $0.id == "code_stroke" }
        
        guard let protocol = strokeProtocol else {
            Issue.record("Code Stroke protocol not found")
            return
        }
        
        let thrombolysisNode = protocol.algorithm.nodes.first { $0.id == "thrombolysis" }
        
        #expect(thrombolysisNode != nil)
        #expect(thrombolysisNode?.critical == true)
        #expect(thrombolysisNode?.content.contains("TNK"))
        #expect(thrombolysisNode?.content.contains("0.25mg/kg"))
    }
    
    // MARK: - Anaphylaxis Protocol Tests (CRITICAL)
    
    @Test func testAnaphylaxisProtocolStructure() async throws {
        let service = EmergencyProtocolService()
        let anaphylaxisProtocol = service.protocols.first { $0.id == "anaphylaxis_protocol" }
        
        #expect(anaphylaxisProtocol != nil)
        guard let protocol = anaphylaxisProtocol else { return }
        
        #expect(protocol.title == "Anaphylaxis Management")
        #expect(protocol.category == .allergic)
        #expect(protocol.icon == "bx-shield-x")
        #expect(protocol.algorithm.nodes.count > 0)
        #expect(protocol.cards.count == 3)
    }
    
    @Test func testAnaphylaxisEpinephrineDosing() async throws {
        let service = EmergencyProtocolService()
        let anaphylaxisProtocol = service.protocols.first { $0.id == "anaphylaxis_protocol" }
        
        guard let protocol = anaphylaxisProtocol else {
            Issue.record("Anaphylaxis protocol not found")
            return
        }
        
        let epinephrineNode = protocol.algorithm.nodes.first { $0.id == "epinephrine_im" }
        
        #expect(epinephrineNode != nil)
        #expect(epinephrineNode?.critical == true)
        #expect(epinephrineNode?.nodeType == .medication)
        #expect(epinephrineNode?.content.contains("0.5mg"))
        #expect(epinephrineNode?.content.contains("1:1000"))
        #expect(epinephrineNode?.content.contains("anterolateral thigh"))
    }
    
    @Test func testAnaphylaxisCriticalPriority() async throws {
        let service = EmergencyProtocolService()
        let anaphylaxisProtocol = service.protocols.first { $0.id == "anaphylaxis_protocol" }
        
        guard let protocol = anaphylaxisProtocol else {
            Issue.record("Anaphylaxis protocol not found")
            return
        }
        
        let dynamicCard = protocol.cards.first { $0.type == .dynamic }
        let prioritySection = dynamicCard?.sections.first { $0.title.contains("Priority") }
        
        #expect(dynamicCard != nil)
        #expect(prioritySection != nil)
        #expect(prioritySection?.items.first?.contains("FIRST-LINE") == true)
    }
    
    // MARK: - RSI Protocol Tests
    
    @Test func testRSIProtocolStructure() async throws {
        let service = EmergencyProtocolService()
        let rsiProtocol = service.protocols.first { $0.id == "rsi_protocol" }
        
        #expect(rsiProtocol != nil)
        guard let protocol = rsiProtocol else { return }
        
        #expect(protocol.title == "RSI & Advanced Airway")
        #expect(protocol.category == .respiratory)
        #expect(protocol.icon == "bx-lungs")
    }
    
    @Test func testRSIMedicationDosing() async throws {
        let service = EmergencyProtocolService()
        let rsiProtocol = service.protocols.first { $0.id == "rsi_protocol" }
        
        guard let protocol = rsiProtocol else {
            Issue.record("RSI protocol not found")
            return
        }
        
        let inductionNode = protocol.algorithm.nodes.first { $0.id == "induction" }
        let paralysisNode = protocol.algorithm.nodes.first { $0.id == "paralysis" }
        
        #expect(inductionNode != nil)
        #expect(inductionNode?.critical == true)
        #expect(inductionNode?.content.contains("Ketamine 1-2mg/kg"))
        
        #expect(paralysisNode != nil)
        #expect(paralysisNode?.critical == true)
        #expect(paralysisNode?.content.contains("Rocuronium 1-1.2mg/kg"))
    }
    
    // MARK: - Protocol Validation Tests
    
    @Test func testAllProtocolsHaveRequiredFields() async throws {
        let service = EmergencyProtocolService()
        
        for protocol in service.protocols {
            #expect(!protocol.id.isEmpty, "Protocol ID cannot be empty")
            #expect(!protocol.title.isEmpty, "Protocol title cannot be empty")
            #expect(!protocol.icon.isEmpty, "Protocol icon cannot be empty")
            #expect(protocol.algorithm.nodes.count > 0, "Protocol must have algorithm nodes")
            #expect(protocol.cards.count > 0, "Protocol must have cards")
        }
    }
    
    @Test func testAllProtocolsHaveUniqueIds() async throws {
        let service = EmergencyProtocolService()
        let protocolIds = service.protocols.map { $0.id }
        let uniqueIds = Set(protocolIds)
        
        #expect(protocolIds.count == uniqueIds.count, "All protocol IDs must be unique")
    }
    
    @Test func testCriticalProtocolsHaveCorrectCategories() async throws {
        let service = EmergencyProtocolService()
        
        let codeBlue = service.protocols.first { $0.id == "code_blue" }
        let codeStroke = service.protocols.first { $0.id == "code_stroke" }
        let codeStemi = service.protocols.first { $0.id == "code_stemi" }
        let anaphylaxis = service.protocols.first { $0.id == "anaphylaxis_protocol" }
        let rsi = service.protocols.first { $0.id == "rsi_protocol" }
        
        #expect(codeBlue?.category == .cardiac)
        #expect(codeStroke?.category == .neurological)
        #expect(codeStemi?.category == .cardiac)
        #expect(anaphylaxis?.category == .allergic)
        #expect(rsi?.category == .respiratory)
    }
    
    // MARK: - Algorithm Node Validation Tests
    
    @Test func testDecisionNodesHaveMultipleConnections() async throws {
        let service = EmergencyProtocolService()
        
        for protocol in service.protocols {
            for node in protocol.algorithm.nodes {
                if node.nodeType == .decision {
                    #expect(node.connections.count >= 2,
                           "Decision node '\(node.id)' in protocol '\(protocol.id)' must have at least 2 connections")
                }
            }
        }
    }
    
    @Test func testMedicationNodesAreCritical() async throws {
        let service = EmergencyProtocolService()
        
        for protocol in service.protocols {
            for node in protocol.algorithm.nodes {
                if node.nodeType == .medication {
                    #expect(node.critical == true,
                           "Medication node '\(node.id)' in protocol '\(protocol.id)' must be marked as critical")
                }
            }
        }
    }
    
    @Test func testEndpointNodesHaveNoConnections() async throws {
        let service = EmergencyProtocolService()
        
        for protocol in service.protocols {
            for node in protocol.algorithm.nodes {
                if node.nodeType == .endpoint {
                    #expect(node.connections.isEmpty,
                           "Endpoint node '\(node.id)' in protocol '\(protocol.id)' should have no connections")
                }
            }
        }
    }
    
    // MARK: - Protocol Card Tests
    
    @Test func testProtocolCardsHaveContent() async throws {
        let service = EmergencyProtocolService()
        
        for protocol in service.protocols {
            #expect(protocol.cards.count >= 3, "Protocol '\(protocol.id)' should have at least 3 cards")
            
            let hasdinamicCard = protocol.cards.contains { $0.type == .dynamic }
            let hasAssessmentCard = protocol.cards.contains { $0.type == .assessment }
            let hasActionsCard = protocol.cards.contains { $0.type == .actions }
            
            #expect(hasdinamicCard, "Protocol '\(protocol.id)' must have a dynamic card")
            #expect(hasAssessmentCard, "Protocol '\(protocol.id)' must have an assessment card")
            #expect(hasActionsCard, "Protocol '\(protocol.id)' must have an actions card")
        }
    }
    
    @Test func testCardSectionsHaveContent() async throws {
        let service = EmergencyProtocolService()
        
        for protocol in service.protocols {
            for card in protocol.cards {
                #expect(card.sections.count > 0, "Card '\(card.id)' must have sections")
                
                for section in card.sections {
                    #expect(!section.title.isEmpty, "Section title cannot be empty")
                    #expect(section.items.count > 0, "Section must have items")
                    
                    for item in section.items {
                        #expect(!item.isEmpty, "Section items cannot be empty")
                    }
                }
            }
        }
    }
    
    // MARK: - Performance Tests
    
    @Test func testProtocolLoadingPerformance() async throws {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let service = EmergencyProtocolService()
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let loadingTime = endTime - startTime
        
        #expect(loadingTime < 1.0, "Protocol loading should complete in under 1 second")
        #expect(service.protocols.count > 0, "Protocols should be loaded")
    }
    
    @Test func testProtocolAccessPerformance() async throws {
        let service = EmergencyProtocolService()
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Access each protocol multiple times
        for _ in 0..<100 {
            for protocol in service.protocols {
                _ = protocol.id
                _ = protocol.title
                _ = protocol.algorithm.nodes.count
            }
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let accessTime = endTime - startTime
        
        #expect(accessTime < 0.1, "Protocol access should be very fast")
    }
    
    // MARK: - Memory Safety Tests
    
    @Test func testProtocolServiceMemoryStability() async throws {
        var services: [EmergencyProtocolService] = []
        
        // Create multiple service instances
        for _ in 0..<10 {
            services.append(EmergencyProtocolService())
        }
        
        // Verify all instances have consistent data
        let firstServiceProtocolCount = services[0].protocols.count
        
        for service in services {
            #expect(service.protocols.count == firstServiceProtocolCount,
                   "All service instances should have the same number of protocols")
        }
        
        // Clear references
        services.removeAll()
    }
    
    // MARK: - Critical Dosing Validation Tests
    
    @Test func testEpinephrineDosagesAreCorrect() async throws {
        let service = EmergencyProtocolService()
        
        // Code Blue epinephrine
        let codeBlue = service.protocols.first { $0.id == "code_blue" }
        let codeBlueEpi = codeBlue?.algorithm.nodes.first { $0.id == "epinephrine" }
        #expect(codeBlueEpi?.content.contains("1mg IV/IO") == true)
        
        // Anaphylaxis epinephrine
        let anaphylaxis = service.protocols.first { $0.id == "anaphylaxis_protocol" }
        let anaphylaxisEpi = anaphylaxis?.algorithm.nodes.first { $0.id == "epinephrine_im" }
        #expect(anaphylaxisEpi?.content.contains("0.5mg") == true)
        #expect(anaphylaxisEpi?.content.contains("1:1000") == true)
    }
    
    @Test func testTimeWindowsAreAccurate() async throws {
        let service = EmergencyProtocolService()
        
        // Stroke time window
        let stroke = service.protocols.first { $0.id == "code_stroke" }
        let strokeTime = stroke?.algorithm.nodes.first { $0.id == "time_window" }
        #expect(strokeTime?.content.contains("4.5 hours") == true)
        
        // STEMI time window in cards
        let stemi = service.protocols.first { $0.id == "code_stemi" }
        let stemiCard = stemi?.cards.first { $0.type == .dynamic }
        let timeSection = stemiCard?.sections.first { $0.title.contains("Timeline") }
        #expect(timeSection?.items.contains { $0.contains("90 minutes") } == true)
    }
    
    // MARK: - Algorithm Connectivity Tests
    
    @Test func testAlgorithmNodesFormValidPaths() async throws {
        let service = EmergencyProtocolService()
        
        for protocol in service.protocols {
            let nodeIds = Set(protocol.algorithm.nodes.map { $0.id })
            
            for node in protocol.algorithm.nodes {
                for connection in node.connections {
                    #expect(nodeIds.contains(connection),
                           "Node '\(node.id)' references non-existent connection '\(connection)' in protocol '\(protocol.id)'")
                }
            }
        }
    }
    
    @Test func testAlgorithmHasStartingPoints() async throws {
        let service = EmergencyProtocolService()
        
        for protocol in service.protocols {
            let nodes = protocol.algorithm.nodes
            let allConnections = Set(nodes.flatMap { $0.connections })
            let nodeIds = Set(nodes.map { $0.id })
            
            // Find nodes that are not referenced by any other node (starting points)
            let startingNodes = nodeIds.subtracting(allConnections)
            
            #expect(startingNodes.count > 0,
                   "Protocol '\(protocol.id)' must have at least one starting node")
        }
    }
}
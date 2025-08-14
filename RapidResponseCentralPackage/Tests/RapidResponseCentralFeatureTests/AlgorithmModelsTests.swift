import Testing
@testable import RapidResponseCentralFeature

/// Comprehensive test suite for AlgorithmModels
/// These models are critical for life-saving medical protocols
struct AlgorithmModelsTests {
    
    // MARK: - ProtocolAlgorithm Tests
    
    @Test func testProtocolAlgorithmInitialization() async throws {
        let nodes = [
            createTestAlgorithmNode(id: "node1", title: "Initial Assessment"),
            createTestAlgorithmNode(id: "node2", title: "Decision Point")
        ]
        
        let algorithm = ProtocolAlgorithm(nodes: nodes)
        
        #expect(algorithm.nodes.count == 2)
        #expect(algorithm.nodes[0].id == "node1")
        #expect(algorithm.nodes[1].id == "node2")
    }
    
    @Test func testProtocolAlgorithmEquality() async throws {
        let nodes1 = [createTestAlgorithmNode(id: "node1", title: "Assessment")]
        let nodes2 = [createTestAlgorithmNode(id: "node1", title: "Assessment")]
        
        let algorithm1 = ProtocolAlgorithm(nodes: nodes1)
        let algorithm2 = ProtocolAlgorithm(nodes: nodes2)
        
        #expect(algorithm1 == algorithm2)
    }
    
    // MARK: - AlgorithmNode Tests
    
    @Test func testAlgorithmNodeInitialization() async throws {
        let node = AlgorithmNode(
            id: "test_node",
            title: "Test Assessment",
            nodeType: .assessment,
            critical: true,
            content: "Perform critical assessment",
            connections: ["next_node"]
        )
        
        #expect(node.id == "test_node")
        #expect(node.title == "Test Assessment")
        #expect(node.nodeType == .assessment)
        #expect(node.critical == true)
        #expect(node.content == "Perform critical assessment")
        #expect(node.connections == ["next_node"])
    }
    
    @Test func testAlgorithmNodeCriticalPathIdentification() async throws {
        let criticalNode = createTestAlgorithmNode(id: "critical", critical: true)
        let nonCriticalNode = createTestAlgorithmNode(id: "routine", critical: false)
        
        #expect(criticalNode.critical == true)
        #expect(nonCriticalNode.critical == false)
    }
    
    @Test func testNodeTypeClassification() async throws {
        let decisionNode = createTestAlgorithmNode(nodeType: .decision)
        let assessmentNode = createTestAlgorithmNode(nodeType: .assessment)
        let interventionNode = createTestAlgorithmNode(nodeType: .intervention)
        let medicationNode = createTestAlgorithmNode(nodeType: .medication)
        let endpointNode = createTestAlgorithmNode(nodeType: .endpoint)
        let actionNode = createTestAlgorithmNode(nodeType: .action)
        
        #expect(decisionNode.nodeType == .decision)
        #expect(assessmentNode.nodeType == .assessment)
        #expect(interventionNode.nodeType == .intervention)
        #expect(medicationNode.nodeType == .medication)
        #expect(endpointNode.nodeType == .endpoint)
        #expect(actionNode.nodeType == .action)
    }
    
    @Test func testAlgorithmNodeConnectionsValidation() async throws {
        let nodeWithConnections = createTestAlgorithmNode(
            id: "parent",
            connections: ["child1", "child2", "child3"]
        )
        let nodeWithoutConnections = createTestAlgorithmNode(
            id: "endpoint",
            connections: []
        )
        
        #expect(nodeWithConnections.connections.count == 3)
        #expect(nodeWithConnections.connections.contains("child1"))
        #expect(nodeWithConnections.connections.contains("child2"))
        #expect(nodeWithConnections.connections.contains("child3"))
        #expect(nodeWithoutConnections.connections.isEmpty)
    }
    
    // MARK: - ProtocolCard Tests
    
    @Test func testProtocolCardInitialization() async throws {
        let sections = [
            CardSection(title: "Assessment", items: ["Check vitals", "Monitor patient"]),
            CardSection(title: "Interventions", items: ["Start IV", "Give medication"])
        ]
        
        let card = ProtocolCard(
            id: "test_card",
            type: .assessment,
            title: "Patient Assessment",
            sections: sections
        )
        
        #expect(card.id == "test_card")
        #expect(card.type == .assessment)
        #expect(card.title == "Patient Assessment")
        #expect(card.sections.count == 2)
        #expect(card.sections[0].title == "Assessment")
        #expect(card.sections[1].title == "Interventions")
    }
    
    @Test func testCardTypeClassification() async throws {
        let dynamicCard = ProtocolCard(id: "1", type: .dynamic, title: "Dynamic", sections: [])
        let assessmentCard = ProtocolCard(id: "2", type: .assessment, title: "Assessment", sections: [])
        let actionsCard = ProtocolCard(id: "3", type: .actions, title: "Actions", sections: [])
        
        #expect(dynamicCard.type == .dynamic)
        #expect(assessmentCard.type == .assessment)
        #expect(actionsCard.type == .actions)
    }
    
    // MARK: - CardSection Tests
    
    @Test func testCardSectionInitialization() async throws {
        let items = ["Item 1", "Item 2", "Item 3"]
        let section = CardSection(title: "Test Section", items: items)
        
        #expect(section.title == "Test Section")
        #expect(section.items == items)
        #expect(section.items.count == 3)
    }
    
    @Test func testCardSectionEquality() async throws {
        let section1 = CardSection(title: "Medications", items: ["Aspirin 325mg", "Clopidogrel 75mg"])
        let section2 = CardSection(title: "Medications", items: ["Aspirin 325mg", "Clopidogrel 75mg"])
        let section3 = CardSection(title: "Different", items: ["Different medication"])
        
        #expect(section1 == section2)
        #expect(section1 != section3)
    }
    
    @Test func testCardSectionHashability() async throws {
        let section1 = CardSection(title: "Dosing", items: ["1mg/kg", "2mg/kg"])
        let section2 = CardSection(title: "Dosing", items: ["1mg/kg", "2mg/kg"])
        
        var hasher1 = Hasher()
        var hasher2 = Hasher()
        section1.hash(into: &hasher1)
        section2.hash(into: &hasher2)
        
        #expect(hasher1.finalize() == hasher2.finalize())
    }
    
    // MARK: - ProtocolCategory Tests
    
    @Test func testProtocolCategoryColors() async throws {
        #expect(ProtocolCategory.cardiac.color.description.contains("red"))
        #expect(ProtocolCategory.neurological.color.description.contains("orange"))
        #expect(ProtocolCategory.respiratory.color.description.contains("blue"))
        #expect(ProtocolCategory.trauma.color.description.contains("yellow"))
        #expect(ProtocolCategory.infectious.color.description.contains("purple"))
        #expect(ProtocolCategory.allergic.color.description.contains("pink"))
        #expect(ProtocolCategory.support.color.description.contains("green"))
    }
    
    @Test func testProtocolCategoryAllCases() async throws {
        let allCategories = ProtocolCategory.allCases
        
        #expect(allCategories.count == 7)
        #expect(allCategories.contains(.cardiac))
        #expect(allCategories.contains(.neurological))
        #expect(allCategories.contains(.respiratory))
        #expect(allCategories.contains(.trauma))
        #expect(allCategories.contains(.infectious))
        #expect(allCategories.contains(.allergic))
        #expect(allCategories.contains(.support))
    }
    
    // MARK: - EmergencyProtocol Tests
    
    @Test func testEmergencyProtocolInitialization() async throws {
        let algorithm = ProtocolAlgorithm(nodes: [createTestAlgorithmNode()])
        let cards = [createTestProtocolCard()]
        
        let protocol = EmergencyProtocol(
            id: "test_protocol",
            title: "Test Emergency Protocol",
            icon: "bx-heart",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
        
        #expect(protocol.id == "test_protocol")
        #expect(protocol.title == "Test Emergency Protocol")
        #expect(protocol.icon == "bx-heart")
        #expect(protocol.category == .cardiac)
        #expect(protocol.algorithm.nodes.count == 1)
        #expect(protocol.cards.count == 1)
    }
    
    // MARK: - VisualAid Tests
    
    @Test func testVisualAidInitialization() async throws {
        let annotations = [
            EducationalAnnotation(
                id: "annotation1",
                label: "Important Area",
                description: "This area shows critical information",
                position: AnnotationPosition(x: 0.5, y: 0.3),
                type: .callout,
                color: .danger
            )
        ]
        
        let visualAid = VisualAid(
            id: "ecg_rhythm",
            imageName: "normal_sinus_rhythm",
            title: "Normal Sinus Rhythm",
            description: "Example of normal cardiac rhythm",
            annotations: annotations,
            layout: .aspectRatio,
            interactionType: .zoom
        )
        
        #expect(visualAid.id == "ecg_rhythm")
        #expect(visualAid.imageName == "normal_sinus_rhythm")
        #expect(visualAid.title == "Normal Sinus Rhythm")
        #expect(visualAid.description == "Example of normal cardiac rhythm")
        #expect(visualAid.annotations.count == 1)
        #expect(visualAid.layout == .aspectRatio)
        #expect(visualAid.interactionType == .zoom)
    }
    
    @Test func testAnnotationPositioning() async throws {
        let position = AnnotationPosition(x: 0.25, y: 0.75)
        
        #expect(position.x == 0.25)
        #expect(position.y == 0.75)
    }
    
    @Test func testAnnotationColors() async throws {
        #expect(AnnotationColor.success.color.description.contains("green"))
        #expect(AnnotationColor.danger.color.description.contains("red"))
        #expect(AnnotationColor.warning.color.description.contains("orange"))
        #expect(AnnotationColor.info.color.description.contains("blue"))
    }
    
    // MARK: - EducationalContent Tests
    
    @Test func testEducationalContentInitialization() async throws {
        let keyPoints = [
            KeyPoint(text: "Critical Point", description: "This is very important", importance: .critical),
            KeyPoint(text: "Helpful Tip", description: "This might help", importance: .helpful)
        ]
        
        let content = EducationalContent(
            id: "ecg_education",
            title: "ECG Interpretation",
            description: "Learn to read ECGs",
            contentType: .rhythmRecognition,
            visualAids: [],
            keyPoints: keyPoints
        )
        
        #expect(content.id == "ecg_education")
        #expect(content.title == "ECG Interpretation")
        #expect(content.description == "Learn to read ECGs")
        #expect(content.contentType == .rhythmRecognition)
        #expect(content.keyPoints.count == 2)
    }
    
    @Test func testContentTypeIcons() async throws {
        #expect(ContentType.rhythmRecognition.icon == "waveform.path.ecg")
        #expect(ContentType.procedureGuide.icon == "list.clipboard")
        #expect(ContentType.anatomyReference.icon == "figure.walk")
        #expect(ContentType.medicationGuide.icon == "pills")
    }
    
    @Test func testKeyPointImportance() async throws {
        let criticalPoint = KeyPoint(text: "Critical", description: "Critical info", importance: .critical)
        let importantPoint = KeyPoint(text: "Important", description: "Important info", importance: .important)
        let helpfulPoint = KeyPoint(text: "Helpful", description: "Helpful info", importance: .helpful)
        
        #expect(criticalPoint.importance == .critical)
        #expect(importantPoint.importance == .important)
        #expect(helpfulPoint.importance == .helpful)
        
        #expect(ImportanceLevel.critical.icon == "exclamationmark.triangle.fill")
        #expect(ImportanceLevel.important.icon == "info.circle.fill")
        #expect(ImportanceLevel.helpful.icon == "lightbulb.fill")
    }
    
    @Test func testKeyPointEquality() async throws {
        let point1 = KeyPoint(text: "Same", description: "Same description", importance: .critical)
        let point2 = KeyPoint(text: "Same", description: "Same description", importance: .critical)
        let point3 = KeyPoint(text: "Different", description: "Different description", importance: .critical)
        
        #expect(point1 == point2)
        #expect(point1 != point3)
    }
    
    // MARK: - ContentSizing Tests
    
    @Test func testContentSizingDimensions() async throws {
        #expect(ContentSizing.rhythmChart.minHeight == 120)
        #expect(ContentSizing.rhythmChart.maxHeight == 200)
        
        #expect(ContentSizing.procedureImage.minHeight == 200)
        #expect(ContentSizing.procedureImage.maxHeight == 400)
        
        #expect(ContentSizing.anatomyDiagram.minHeight == 250)
        #expect(ContentSizing.anatomyDiagram.maxHeight == 500)
        
        #expect(ContentSizing.medicationChart.minHeight == 150)
        #expect(ContentSizing.medicationChart.maxHeight == 300)
    }
    
    // MARK: - Helper Methods
    
    private func createTestAlgorithmNode(
        id: String = "test_node",
        title: String = "Test Node",
        nodeType: NodeType = .assessment,
        critical: Bool = false,
        content: String = "Test content",
        connections: [String] = []
    ) -> AlgorithmNode {
        return AlgorithmNode(
            id: id,
            title: title,
            nodeType: nodeType,
            critical: critical,
            content: content,
            connections: connections
        )
    }
    
    private func createTestProtocolCard(
        id: String = "test_card",
        type: CardType = .assessment,
        title: String = "Test Card"
    ) -> ProtocolCard {
        let section = CardSection(title: "Test Section", items: ["Test Item"])
        return ProtocolCard(
            id: id,
            type: type,
            title: title,
            sections: [section]
        )
    }
    
    // MARK: - Critical Path Validation Tests
    
    @Test func testCriticalPathsAreIdentified() async throws {
        let criticalNodes = [
            createTestAlgorithmNode(id: "airway_check", title: "Airway Assessment", critical: true),
            createTestAlgorithmNode(id: "breathing_check", title: "Breathing Assessment", critical: true),
            createTestAlgorithmNode(id: "circulation_check", title: "Circulation Assessment", critical: true)
        ]
        
        let nonCriticalNodes = [
            createTestAlgorithmNode(id: "comfort_measures", title: "Comfort Measures", critical: false),
            createTestAlgorithmNode(id: "documentation", title: "Documentation", critical: false)
        ]
        
        let allNodes = criticalNodes + nonCriticalNodes
        let algorithm = ProtocolAlgorithm(nodes: allNodes)
        
        let criticalCount = algorithm.nodes.filter { $0.critical }.count
        let nonCriticalCount = algorithm.nodes.filter { !$0.critical }.count
        
        #expect(criticalCount == 3)
        #expect(nonCriticalCount == 2)
    }
    
    @Test func testMedicationNodesHaveRequiredContent() async throws {
        let medicationNode = createTestAlgorithmNode(
            id: "epinephrine_dose",
            title: "Epinephrine Administration",
            nodeType: .medication,
            critical: true,
            content: "Epinephrine 1mg IV/IO every 3-5 minutes"
        )
        
        #expect(medicationNode.nodeType == .medication)
        #expect(medicationNode.critical == true)
        #expect(medicationNode.content.contains("mg"))
        #expect(medicationNode.content.contains("IV") || medicationNode.content.contains("IO"))
    }
    
    @Test func testDecisionNodesHaveConnections() async throws {
        let decisionNode = createTestAlgorithmNode(
            id: "pulse_check",
            title: "Pulse Present?",
            nodeType: .decision,
            critical: true,
            content: "Check for pulse within 10 seconds",
            connections: ["pulse_present", "pulse_absent"]
        )
        
        #expect(decisionNode.nodeType == .decision)
        #expect(decisionNode.connections.count >= 2) // Decision nodes should have at least 2 outcomes
        #expect(decisionNode.connections.contains("pulse_present"))
        #expect(decisionNode.connections.contains("pulse_absent"))
    }
}
import SwiftUI

// MARK: - MDCalc-Style Calculator Detail View
public struct CalculatorDetailView: View {
    let calculator: EmergencyProtocol
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var scrollOffset: CGFloat = 0
    @State private var calculatorValues: CalculatorValues = CalculatorValues()
    @State private var showInfo = false
    
    public init(calculator: EmergencyProtocol) {
        self.calculator = calculator
    }
    
    public var body: some View {
        ZStack {
            // Background
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Calculator Form Section
                    VStack(spacing: 20) {
                        // Calculator Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text(calculator.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text(calculatorDescription)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        // Input Fields
                        CalculatorInputSection(
                            calculatorId: calculator.id,
                            values: $calculatorValues
                        )
                        .padding(.horizontal)
                        
                        // Result Display
                        CalculatorResultCard(
                            calculatorId: calculator.id,
                            values: calculatorValues
                        )
                        .padding(.horizontal)
                        
                        // Interpretation Section
                        InterpretationSection(
                            calculatorId: calculator.id,
                            score: calculateScore()
                        )
                        .padding(.horizontal)
                        
                        // Clinical Context
                        ClinicalContextSection(
                            calculatorId: calculator.id
                        )
                        .padding(.horizontal)
                        
                        // References
                        ReferencesSection(
                            calculatorId: calculator.id
                        )
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geometry.frame(in: .named("scroll")).minY
                )
            })
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showInfo.toggle() }) {
                    Image(systemName: "info.circle")
                }
            }
        }
        .sheet(isPresented: $showInfo) {
            CalculatorInfoSheet(calculator: calculator)
        }
    }
    
    private var calculatorDescription: String {
        switch calculator.id {
        case "nih_stroke_scale":
            return "Quantifies stroke severity for treatment planning"
        case "glasgow_coma_scale":
            return "Assesses level of consciousness in acute medical and trauma patients"
        case "chads2vasc2_score":
            return "Calculates stroke risk for patients with atrial fibrillation"
        case "wells_score_pe":
            return "Objectifies risk of pulmonary embolism"
        case "qsofa_score":
            return "Identifies high-risk patients for in-hospital mortality with suspected infection"
        case "curb65_score":
            return "Estimates mortality of community-acquired pneumonia"
        case "creatinine_clearance":
            return "Calculates CrCl for drug dosing adjustments"
        default:
            return "Clinical decision support calculator"
        }
    }
    
    private func calculateScore() -> Double {
        // This would contain actual calculation logic based on calculator type
        return 0.0
    }
}

// MARK: - Calculator Values Model
struct CalculatorValues {
    // NIH Stroke Scale
    var nihConsciousness: Int = 0
    var nihGaze: Int = 0
    var nihVisual: Int = 0
    var nihFacial: Int = 0
    var nihMotorArm: Int = 0
    var nihMotorLeg: Int = 0
    var nihAtaxia: Int = 0
    var nihSensory: Int = 0
    var nihLanguage: Int = 0
    var nihDysarthria: Int = 0
    var nihExtinction: Int = 0
    
    // Glasgow Coma Scale
    var gcsEye: Int = 4
    var gcsVerbal: Int = 5
    var gcsMotor: Int = 6
    
    // CHADS2-VASc
    var chadsAge65to74: Bool = false
    var chadsAge75Plus: Bool = false
    var chadsFemale: Bool = false
    var chadsChf: Bool = false
    var chadsHypertension: Bool = false
    var chadsDiabetes: Bool = false
    var chadsStroke: Bool = false
    var chadsVascular: Bool = false
    
    // Wells PE
    var wellsClinicalDvt: Bool = false
    var wellsAlternativeLess: Bool = false
    var wellsHeartRate: Bool = false
    var wellsImmobilization: Bool = false
    var wellsPreviousPe: Bool = false
    var wellsHemoptysis: Bool = false
    var wellsMalignancy: Bool = false
    
    // qSOFA
    var qsofaRespRate: Bool = false
    var qsofaSysBp: Bool = false
    var qsofaAlteredMental: Bool = false
    
    // CURB-65
    var curbConfusion: Bool = false
    var curbUrea: Bool = false
    var curbRespRate: Bool = false
    var curbBp: Bool = false
    var curbAge65: Bool = false
    
    // Creatinine Clearance
    var creatAge: Double = 50
    var creatWeight: Double = 70
    var creatCreatinine: Double = 1.0
    var creatIsFemale: Bool = false
}

// MARK: - Input Section
struct CalculatorInputSection: View {
    let calculatorId: String
    @Binding var values: CalculatorValues
    
    var body: some View {
        VStack(spacing: 16) {
            switch calculatorId {
            case "nih_stroke_scale":
                NIHStrokeInputs(values: $values)
            case "glasgow_coma_scale":
                GlasgowComaInputs(values: $values)
            case "chads2vasc2_score":
                CHADS2VascInputs(values: $values)
            case "wells_score_pe":
                WellsPEInputs(values: $values)
            case "qsofa_score":
                QSOFAInputs(values: $values)
            case "curb65_score":
                CURB65Inputs(values: $values)
            case "creatinine_clearance":
                CreatinineClearanceInputs(values: $values)
            default:
                EmptyView()
            }
        }
    }
}

// MARK: - Result Card
struct CalculatorResultCard: View {
    let calculatorId: String
    let values: CalculatorValues
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Result")
                    .font(.headline)
                Spacer()
                Text(formattedScore)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(scoreColor)
            }
            
            if let interpretation = scoreInterpretation {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    Text(interpretation)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? 
                      Color(UIColor.secondarySystemBackground) : 
                      Color(UIColor.systemGray6))
        )
    }
    
    private var score: Double {
        switch calculatorId {
        case "glasgow_coma_scale":
            return Double(values.gcsEye + values.gcsVerbal + values.gcsMotor)
        case "chads2vasc2_score":
            var total = 0
            if values.chadsAge65to74 { total += 1 }
            if values.chadsAge75Plus { total += 2 }
            if values.chadsFemale { total += 1 }
            if values.chadsChf { total += 1 }
            if values.chadsHypertension { total += 1 }
            if values.chadsDiabetes { total += 1 }
            if values.chadsStroke { total += 2 }
            if values.chadsVascular { total += 1 }
            return Double(total)
        case "wells_score_pe":
            var total = 0.0
            if values.wellsClinicalDvt { total += 3.0 }
            if values.wellsAlternativeLess { total += 3.0 }
            if values.wellsHeartRate { total += 1.5 }
            if values.wellsImmobilization { total += 1.5 }
            if values.wellsPreviousPe { total += 1.5 }
            if values.wellsHemoptysis { total += 1.0 }
            if values.wellsMalignancy { total += 1.0 }
            return total
        case "qsofa_score":
            var total = 0
            if values.qsofaRespRate { total += 1 }
            if values.qsofaSysBp { total += 1 }
            if values.qsofaAlteredMental { total += 1 }
            return Double(total)
        case "curb65_score":
            var total = 0
            if values.curbConfusion { total += 1 }
            if values.curbUrea { total += 1 }
            if values.curbRespRate { total += 1 }
            if values.curbBp { total += 1 }
            if values.curbAge65 { total += 1 }
            return Double(total)
        case "creatinine_clearance":
            let baseCalc = ((140 - values.creatAge) * values.creatWeight) / (72 * values.creatCreatinine)
            return values.creatIsFemale ? baseCalc * 0.85 : baseCalc
        default:
            return 0
        }
    }
    
    private var formattedScore: String {
        if calculatorId == "creatinine_clearance" {
            return String(format: "%.1f mL/min", score)
        } else if calculatorId == "wells_score_pe" && score.truncatingRemainder(dividingBy: 1) != 0 {
            return String(format: "%.1f", score)
        } else {
            return String(format: "%.0f", score)
        }
    }
    
    private var scoreColor: Color {
        switch calculatorId {
        case "glasgow_coma_scale":
            if score >= 13 { return .green }
            else if score >= 9 { return .orange }
            else { return .red }
        case "chads2vasc2_score":
            if score == 0 { return .green }
            else if score == 1 { return .yellow }
            else { return .red }
        case "wells_score_pe":
            if score < 2 { return .green }
            else if score <= 6 { return .orange }
            else { return .red }
        case "qsofa_score":
            if score < 2 { return .green }
            else { return .red }
        case "curb65_score":
            if score <= 1 { return .green }
            else if score == 2 { return .orange }
            else { return .red }
        default:
            return .primary
        }
    }
    
    private var scoreInterpretation: String? {
        switch calculatorId {
        case "glasgow_coma_scale":
            if score >= 13 { return "Mild" }
            else if score >= 9 { return "Moderate" }
            else { return "Severe" }
        case "chads2vasc2_score":
            if score == 0 { return "Low risk" }
            else if score == 1 { return "Low-moderate risk" }
            else if score == 2 { return "Moderate risk" }
            else { return "High risk" }
        case "wells_score_pe":
            if score < 2 { return "Low probability" }
            else if score <= 6 { return "Moderate probability" }
            else { return "High probability" }
        case "qsofa_score":
            if score >= 2 { return "High risk for poor outcome" }
            else { return "Low risk" }
        case "curb65_score":
            if score <= 1 { return "Low risk - Consider outpatient" }
            else if score == 2 { return "Moderate risk - Consider admission" }
            else { return "High risk - Admit, consider ICU" }
        default:
            return nil
        }
    }
}

// MARK: - Interpretation Section
struct InterpretationSection: View {
    let calculatorId: String
    let score: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Interpretation")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(interpretationItems, id: \.self) { item in
                    HStack(alignment: .top) {
                        Image(systemName: "chevron.right.circle.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        Text(item)
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var interpretationItems: [String] {
        switch calculatorId {
        case "glasgow_coma_scale":
            return [
                "GCS 13-15: Mild brain injury",
                "GCS 9-12: Moderate brain injury",
                "GCS 3-8: Severe brain injury",
                "Consider intubation if GCS ≤8"
            ]
        case "chads2vasc2_score":
            return [
                "Score 0: No anticoagulation recommended",
                "Score 1: Consider anticoagulation",
                "Score ≥2: Anticoagulation recommended",
                "Balance stroke risk vs bleeding risk"
            ]
        case "wells_score_pe":
            return [
                "Low probability (<2): Consider D-dimer",
                "Moderate (2-6): Consider D-dimer or imaging",
                "High (>6): Proceed directly to imaging",
                "Use with clinical judgment"
            ]
        default:
            return []
        }
    }
}

// MARK: - Clinical Context Section
struct ClinicalContextSection: View {
    let calculatorId: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Clinical Context")
                .font(.headline)
            
            Text(contextText)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var contextText: String {
        switch calculatorId {
        case "glasgow_coma_scale":
            return "The GCS is widely used to assess level of consciousness after head injury. It has good inter-rater reliability and helps guide treatment decisions including need for intubation and CT imaging."
        case "chads2vasc2_score":
            return "CHADS2-VASc helps stratify stroke risk in atrial fibrillation patients. It improves upon CHADS2 by better identifying truly low-risk patients who may not require anticoagulation."
        case "wells_score_pe":
            return "Wells' Criteria risk stratifies patients for pulmonary embolism. It should be used with D-dimer testing or imaging based on pre-test probability."
        default:
            return "This calculator provides clinical decision support based on validated scoring systems."
        }
    }
}

// MARK: - References Section
struct ReferencesSection: View {
    let calculatorId: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("References")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(references, id: \.self) { reference in
                    Text("• \(reference)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var references: [String] {
        switch calculatorId {
        case "glasgow_coma_scale":
            return [
                "Teasdale G, et al. Lancet 1974",
                "Healey C, et al. J Neurotrauma 2003"
            ]
        case "chads2vasc2_score":
            return [
                "Lip GY, et al. Chest 2010",
                "January CT, et al. Circulation 2014"
            ]
        case "wells_score_pe":
            return [
                "Wells PS, et al. Thromb Haemost 2000",
                "Wolf SJ, et al. Ann Emerg Med 2018"
            ]
        default:
            return []
        }
    }
}

// MARK: - Info Sheet
struct CalculatorInfoSheet: View {
    let calculator: EmergencyProtocol
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("About This Calculator")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("This calculator has been validated in multiple studies and is widely used in clinical practice.")
                        .font(.body)
                    
                    // Add more detailed information about the calculator
                }
                .padding()
            }
            .navigationTitle(calculator.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
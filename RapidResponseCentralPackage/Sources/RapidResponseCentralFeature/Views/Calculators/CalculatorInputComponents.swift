import SwiftUI

// MARK: - NIH Stroke Scale Inputs
struct NIHStrokeInputs: View {
    @Binding var values: CalculatorValues
    
    var body: some View {
        VStack(spacing: 16) {
            InputSection(title: "Level of Consciousness") {
                Picker("Consciousness", selection: $values.nihConsciousness) {
                    Text("Alert (0)").tag(0)
                    Text("Drowsy (1)").tag(1)
                    Text("Stuporous (2)").tag(2)
                    Text("Coma (3)").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            InputSection(title: "Best Gaze") {
                Picker("Gaze", selection: $values.nihGaze) {
                    Text("Normal (0)").tag(0)
                    Text("Partial palsy (1)").tag(1)
                    Text("Forced deviation (2)").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            InputSection(title: "Visual Fields") {
                Picker("Visual", selection: $values.nihVisual) {
                    Text("Normal (0)").tag(0)
                    Text("Partial hemianopia (1)").tag(1)
                    Text("Complete hemianopia (2)").tag(2)
                    Text("Bilateral hemianopia (3)").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}

// MARK: - Glasgow Coma Scale Inputs
struct GlasgowComaInputs: View {
    @Binding var values: CalculatorValues
    
    var body: some View {
        VStack(spacing: 16) {
            InputSection(title: "Eye Opening") {
                Picker("Eye Opening", selection: $values.gcsEye) {
                    Text("None (1)").tag(1)
                    Text("To pain (2)").tag(2)
                    Text("To speech (3)").tag(3)
                    Text("Spontaneous (4)").tag(4)
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(Color(UIColor.tertiarySystemFill))
                .cornerRadius(8)
            }
            
            InputSection(title: "Verbal Response") {
                Picker("Verbal Response", selection: $values.gcsVerbal) {
                    Text("None (1)").tag(1)
                    Text("Incomprehensible (2)").tag(2)
                    Text("Inappropriate (3)").tag(3)
                    Text("Confused (4)").tag(4)
                    Text("Oriented (5)").tag(5)
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(Color(UIColor.tertiarySystemFill))
                .cornerRadius(8)
            }
            
            InputSection(title: "Motor Response") {
                Picker("Motor Response", selection: $values.gcsMotor) {
                    Text("None (1)").tag(1)
                    Text("Extension (2)").tag(2)
                    Text("Flexion (3)").tag(3)
                    Text("Withdrawal (4)").tag(4)
                    Text("Localizes (5)").tag(5)
                    Text("Obeys (6)").tag(6)
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(Color(UIColor.tertiarySystemFill))
                .cornerRadius(8)
            }
        }
    }
}

// MARK: - CHADS2-VASc Inputs
struct CHADS2VascInputs: View {
    @Binding var values: CalculatorValues
    
    var body: some View {
        VStack(spacing: 12) {
            CheckboxRow(
                title: "Congestive Heart Failure",
                subtitle: "+1 point",
                isChecked: $values.chadsChf
            )
            
            CheckboxRow(
                title: "Hypertension",
                subtitle: "+1 point",
                isChecked: $values.chadsHypertension
            )
            
            CheckboxRow(
                title: "Age 65-74 years",
                subtitle: "+1 point",
                isChecked: $values.chadsAge65to74
            )
            
            CheckboxRow(
                title: "Age ≥75 years",
                subtitle: "+2 points",
                isChecked: $values.chadsAge75Plus
            )
            
            CheckboxRow(
                title: "Diabetes Mellitus",
                subtitle: "+1 point",
                isChecked: $values.chadsDiabetes
            )
            
            CheckboxRow(
                title: "Stroke/TIA/Thromboembolism",
                subtitle: "+2 points",
                isChecked: $values.chadsStroke
            )
            
            CheckboxRow(
                title: "Vascular Disease",
                subtitle: "+1 point",
                isChecked: $values.chadsVascular
            )
            
            CheckboxRow(
                title: "Female Sex",
                subtitle: "+1 point",
                isChecked: $values.chadsFemale
            )
        }
    }
}

// MARK: - Wells PE Inputs
struct WellsPEInputs: View {
    @Binding var values: CalculatorValues
    
    var body: some View {
        VStack(spacing: 12) {
            CheckboxRow(
                title: "Clinical signs of DVT",
                subtitle: "+3 points",
                isChecked: $values.wellsClinicalDvt
            )
            
            CheckboxRow(
                title: "PE is most likely diagnosis",
                subtitle: "+3 points",
                isChecked: $values.wellsAlternativeLess
            )
            
            CheckboxRow(
                title: "Heart rate >100",
                subtitle: "+1.5 points",
                isChecked: $values.wellsHeartRate
            )
            
            CheckboxRow(
                title: "Immobilization/surgery in past 4 weeks",
                subtitle: "+1.5 points",
                isChecked: $values.wellsImmobilization
            )
            
            CheckboxRow(
                title: "Previous DVT/PE",
                subtitle: "+1.5 points",
                isChecked: $values.wellsPreviousPe
            )
            
            CheckboxRow(
                title: "Hemoptysis",
                subtitle: "+1 point",
                isChecked: $values.wellsHemoptysis
            )
            
            CheckboxRow(
                title: "Malignancy",
                subtitle: "+1 point",
                isChecked: $values.wellsMalignancy
            )
        }
    }
}

// MARK: - qSOFA Inputs
struct QSOFAInputs: View {
    @Binding var values: CalculatorValues
    
    var body: some View {
        VStack(spacing: 12) {
            CheckboxRow(
                title: "Respiratory rate ≥22/min",
                subtitle: "+1 point",
                isChecked: $values.qsofaRespRate
            )
            
            CheckboxRow(
                title: "Systolic BP ≤100 mmHg",
                subtitle: "+1 point",
                isChecked: $values.qsofaSysBp
            )
            
            CheckboxRow(
                title: "Altered mental status",
                subtitle: "+1 point",
                isChecked: $values.qsofaAlteredMental
            )
        }
    }
}

// MARK: - CURB-65 Inputs
struct CURB65Inputs: View {
    @Binding var values: CalculatorValues
    
    var body: some View {
        VStack(spacing: 12) {
            CheckboxRow(
                title: "Confusion",
                subtitle: "+1 point",
                isChecked: $values.curbConfusion
            )
            
            CheckboxRow(
                title: "Urea >7 mmol/L (BUN >19 mg/dL)",
                subtitle: "+1 point",
                isChecked: $values.curbUrea
            )
            
            CheckboxRow(
                title: "Respiratory rate ≥30/min",
                subtitle: "+1 point",
                isChecked: $values.curbRespRate
            )
            
            CheckboxRow(
                title: "Blood pressure (SBP <90 or DBP ≤60)",
                subtitle: "+1 point",
                isChecked: $values.curbBp
            )
            
            CheckboxRow(
                title: "Age ≥65 years",
                subtitle: "+1 point",
                isChecked: $values.curbAge65
            )
        }
    }
}

// MARK: - Creatinine Clearance Inputs
struct CreatinineClearanceInputs: View {
    @Binding var values: CalculatorValues
    
    var body: some View {
        VStack(spacing: 16) {
            InputSection(title: "Age (years)") {
                HStack {
                    Slider(value: $values.creatAge, in: 18...100, step: 1)
                    Text("\(Int(values.creatAge))")
                        .frame(width: 40)
                        .font(.system(.body, design: .monospaced))
                }
            }
            
            InputSection(title: "Weight (kg)") {
                HStack {
                    Slider(value: $values.creatWeight, in: 30...200, step: 1)
                    Text("\(Int(values.creatWeight))")
                        .frame(width: 40)
                        .font(.system(.body, design: .monospaced))
                }
            }
            
            InputSection(title: "Serum Creatinine (mg/dL)") {
                HStack {
                    TextField("Creatinine", value: $values.creatCreatinine, format: .number.precision(.fractionLength(1)))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    Text("mg/dL")
                        .foregroundColor(.secondary)
                }
            }
            
            CheckboxRow(
                title: "Female",
                subtitle: "Multiply result by 0.85",
                isChecked: $values.creatIsFemale
            )
        }
    }
}

// MARK: - Reusable Components

struct InputSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            content
        }
    }
}

struct CheckboxRow: View {
    let title: String
    let subtitle: String
    @Binding var isChecked: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: { isChecked.toggle() }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? .blue : .secondary)
                    .font(.title2)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorScheme == .dark ? 
                          Color(UIColor.secondarySystemBackground) : 
                          Color(UIColor.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
import Foundation

nonisolated enum ExperienceLevel: String, Codable, CaseIterable, Sendable {
    case beginner
    case intermediate
    case advanced
    case elite
}

nonisolated enum BiologicalSex: String, Codable, CaseIterable, Sendable {
    case male
    case female
    case other
}

nonisolated struct CalibrationMetrics: Codable, Sendable {
    var vdotEstimate: Double?
    var strengthTier: String?
    var mobilityScore: Int?
    var cardioBaselineMinutes: Int?
    var recoveryScore: Int?

    enum CodingKeys: String, CodingKey {
        case vdotEstimate
        case strengthTier
        case mobilityScore
        case cardioBaselineMinutes
        case recoveryScore
    }

    init(
        vdotEstimate: Double? = nil,
        strengthTier: String? = nil,
        mobilityScore: Int? = nil,
        cardioBaselineMinutes: Int? = nil,
        recoveryScore: Int? = nil
    ) {
        self.vdotEstimate = vdotEstimate
        self.strengthTier = strengthTier
        self.mobilityScore = mobilityScore
        self.cardioBaselineMinutes = cardioBaselineMinutes
        self.recoveryScore = recoveryScore
    }
}

nonisolated struct Injury: Codable, Identifiable, Sendable {
    let id: UUID
    let name: String
    let bodyPart: String
    let severity: String
    let notes: String?
    let dateReported: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case bodyPart
        case severity
        case notes
        case dateReported
    }

    init(
        id: UUID = UUID(),
        name: String,
        bodyPart: String,
        severity: String,
        notes: String? = nil,
        dateReported: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.bodyPart = bodyPart
        self.severity = severity
        self.notes = notes
        self.dateReported = dateReported ?? Date()
    }
}

nonisolated struct Assessment: Codable, Identifiable, Sendable {
    let id: UUID
    var experienceLevel: ExperienceLevel
    var activityDays: Int
    var runningBaselinePace: Double?
    var strengthBaseline: String?
    var injuries: [Injury]
    var age: Int?
    var sex: BiologicalSex?
    var ageSetDate: Date
    var calibration: CalibrationMetrics
    var createdAt: Date
    var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case experienceLevel
        case activityDays
        case runningBaselinePace
        case strengthBaseline
        case injuries
        case age
        case sex
        case ageSetDate
        case calibration
        case createdAt
        case updatedAt
    }

    init(
        id: UUID = UUID(),
        experienceLevel: ExperienceLevel = .intermediate,
        activityDays: Int = 3,
        runningBaselinePace: Double? = nil,
        strengthBaseline: String? = nil,
        injuries: [Injury] = [],
        age: Int? = nil,
        sex: BiologicalSex? = nil,
        ageSetDate: Date? = nil,
        calibration: CalibrationMetrics = CalibrationMetrics()
    ) {
        self.id = id
        self.experienceLevel = experienceLevel
        self.activityDays = activityDays
        self.runningBaselinePace = runningBaselinePace
        self.strengthBaseline = strengthBaseline
        self.injuries = injuries
        self.age = age
        self.sex = sex
        self.ageSetDate = ageSetDate ?? Date()
        self.calibration = calibration
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    // MARK: - Computed Properties

    var hasInjuries: Bool {
        !injuries.isEmpty
    }

    var injuryCount: Int {
        injuries.count
    }

    var hasRunningBaseline: Bool {
        runningBaselinePace != nil
    }

    var hasStrengthBaseline: Bool {
        strengthBaseline != nil
    }

    var canPerformRun: Bool {
        !injuries.contains { $0.bodyPart.lowercased().contains("leg") ||
            $0.bodyPart.lowercased().contains("knee") ||
            $0.bodyPart.lowercased().contains("ankle") ||
            $0.bodyPart.lowercased().contains("foot") }
    }

    var canPerformStrength: Bool {
        !injuries.contains { $0.bodyPart.lowercased().contains("arm") ||
            $0.bodyPart.lowercased().contains("shoulder") ||
            $0.bodyPart.lowercased().contains("back") }
    }

    var canPerformCore: Bool {
        !injuries.contains { $0.bodyPart.lowercased().contains("back") ||
            $0.bodyPart.lowercased().contains("abdomen") ||
            $0.bodyPart.lowercased().contains("core") }
    }

    var experienceLevelDescription: String {
        switch experienceLevel {
        case .beginner:
            return "Just starting out"
        case .intermediate:
            return "Some training experience"
        case .advanced:
            return "Consistent training history"
        case .elite:
            return "Competitive athlete"
        }
    }

    var isYoung: Bool {
        guard let age = age else { return false }
        return age < 35
    }

    var isMiddleAged: Bool {
        guard let age = age else { return false }
        return age >= 35 && age < 55
    }

    var isSenior: Bool {
        guard let age = age else { return false }
        return age >= 55
    }

    var vdotEstimate: Double? {
        calibration.vdotEstimate
    }

    var strengthTier: String? {
        calibration.strengthTier
    }

    var mobilityScore: Int? {
        calibration.mobilityScore
    }

    var daysSinceAgeSet: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: ageSetDate, to: Date())
        return components.day ?? 0
    }

    var currentAge: Int? {
        guard let age = age else { return nil }
        let yearsElapsed = daysSinceAgeSet / 365
        return age + yearsElapsed
    }

    var isDueForRecalibration: Bool {
        daysSinceAgeSet > 90
    }

    var nearestInjury: Injury? {
        injuries.min { ($0.dateReported ?? Date()) > ($1.dateReported ?? Date()) }
    }

    var hasSevereInjury: Bool {
        injuries.contains { $0.severity.lowercased() == "severe" || $0.severity.lowercased() == "critical" }
    }
}

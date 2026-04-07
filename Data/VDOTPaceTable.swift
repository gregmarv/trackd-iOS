import Foundation

/// Daniels' VDOT pace lookup table for running training zones
/// Maps VDOT values (25-60) to pace recommendations for different training zones
final class VDOTPaceTable {
    /// Complete VDOT pace data from Daniels' Running Formula
    /// Format: VDOT -> [PaceZone: pace in mm:ss format]
    private let paceTable: [Int: [PaceZone: String]] = [
        25: [.easy: "10:48", .tempo: "08:30", .interval: "07:20", .race5k: "06:50", .recovery: "12:00"],
        26: [.easy: "10:36", .tempo: "08:22", .interval: "07:12", .race5k: "06:42", .recovery: "11:48"],
        27: [.easy: "10:24", .tempo: "08:14", .interval: "07:04", .race5k: "06:34", .recovery: "11:36"],
        28: [.easy: "10:12", .tempo: "08:06", .interval: "06:56", .race5k: "06:27", .recovery: "11:24"],
        29: [.easy: "10:00", .tempo: "07:58", .interval: "06:48", .race5k: "06:19", .recovery: "11:12"],
        30: [.easy: "09:48", .tempo: "07:50", .interval: "06:40", .race5k: "06:11", .recovery: "11:00"],
        31: [.easy: "09:36", .tempo: "07:42", .interval: "06:32", .race5k: "06:03", .recovery: "10:48"],
        32: [.easy: "09:26", .tempo: "07:34", .interval: "06:25", .race5k: "05:56", .recovery: "10:36"],
        33: [.easy: "09:14", .tempo: "07:27", .interval: "06:18", .race5k: "05:49", .recovery: "10:24"],
        34: [.easy: "09:02", .tempo: "07:19", .interval: "06:11", .race5k: "05:42", .recovery: "10:12"],
        35: [.easy: "08:50", .tempo: "07:11", .interval: "06:04", .race5k: "05:34", .recovery: "10:00"],
        36: [.easy: "08:40", .tempo: "07:04", .interval: "05:57", .race5k: "05:27", .recovery: "09:48"],
        37: [.easy: "08:28", .tempo: "06:56", .interval: "05:50", .race5k: "05:20", .recovery: "09:36"],
        38: [.easy: "08:16", .tempo: "06:49", .interval: "05:43", .race5k: "05:13", .recovery: "09:24"],
        39: [.easy: "08:06", .tempo: "06:41", .interval: "05:36", .race5k: "05:06", .recovery: "09:12"],
        40: [.easy: "07:54", .tempo: "06:33", .interval: "05:29", .race5k: "04:59", .recovery: "09:00"],
        41: [.easy: "07:44", .tempo: "06:26", .interval: "05:22", .race5k: "04:53", .recovery: "08:48"],
        42: [.easy: "07:32", .tempo: "06:19", .interval: "05:15", .race5k: "04:46", .recovery: "08:36"],
        43: [.easy: "07:20", .tempo: "06:11", .interval: "05:08", .race5k: "04:39", .recovery: "08:24"],
        44: [.easy: "07:10", .tempo: "06:04", .interval: "05:02", .race5k: "04:33", .recovery: "08:12"],
        45: [.easy: "06:58", .tempo: "05:56", .interval: "04:55", .race5k: "04:26", .recovery: "08:00"],
        46: [.easy: "06:48", .tempo: "05:49", .interval: "04:48", .race5k: "04:19", .recovery: "07:48"],
        47: [.easy: "06:36", .tempo: "05:42", .interval: "04:41", .race5k: "04:12", .recovery: "07:36"],
        48: [.easy: "06:26", .tempo: "05:34", .interval: "04:35", .race5k: "04:06", .recovery: "07:24"],
        49: [.easy: "06:14", .tempo: "05:27", .interval: "04:28", .race5k: "03:59", .recovery: "07:12"],
        50: [.easy: "06:04", .tempo: "05:20", .interval: "04:21", .race5k: "03:52", .recovery: "07:00"],
        51: [.easy: "05:52", .tempo: "05:12", .interval: "04:15", .race5k: "03:46", .recovery: "06:48"],
        52: [.easy: "05:42", .tempo: "05:05", .interval: "04:08", .race5k: "03:39", .recovery: "06:36"],
        53: [.easy: "05:30", .tempo: "04:58", .interval: "04:01", .race5k: "03:33", .recovery: "06:24"],
        54: [.easy: "05:20", .tempo: "04:51", .interval: "03:55", .race5k: "03:26", .recovery: "06:12"],
        55: [.easy: "05:10", .tempo: "04:43", .interval: "03:48", .race5k: "03:20", .recovery: "06:00"],
        56: [.easy: "04:58", .tempo: "04:36", .interval: "03:42", .race5k: "03:13", .recovery: "05:48"],
        57: [.easy: "04:48", .tempo: "04:29", .interval: "03:35", .race5k: "03:07", .recovery: "05:36"],
        58: [.easy: "04:36", .tempo: "04:22", .interval: "03:29", .race5k: "03:00", .recovery: "05:24"],
        59: [.easy: "04:26", .tempo: "04:14", .interval: "03:22", .race5k: "02:54", .recovery: "05:12"],
        60: [.easy: "04:16", .tempo: "04:07", .interval: "03:16", .race5k: "02:47", .recovery: "05:00"],
    ]

    init() {}

    /// Retrieves pace for a given VDOT and training zone
    /// - Parameters:
    ///   - vdot: VDOT value (25-60)
    ///   - zone: Training zone (easy, tempo, interval, race5k, recovery)
    /// - Returns: Pace string in mm:ss format per mile, or nil if VDOT out of range
    func getPace(vdot: Int, zone: PaceZone) -> String? {
        guard let paces = paceTable[vdot] else { return nil }
        return paces[zone]
    }

    /// Retrieves all paces for a given VDOT value
    /// - Parameter vdot: VDOT value (25-60)
    /// - Returns: Dictionary of pace zones to pace strings, or empty dict if VDOT out of range
    func getAllPaces(vdot: Int) -> [PaceZone: String] {
        return paceTable[vdot] ?? [:]
    }

    /// Checks if a VDOT value is valid in the table
    /// - Parameter vdot: VDOT value to check
    /// - Returns: true if VDOT is in range (25-60)
    func isValidVDOT(_ vdot: Int) -> Bool {
        return vdot >= 25 && vdot <= 60 && paceTable[vdot] != nil
    }

    /// Gets the VDOT range supported by this table
    /// - Returns: Tuple with min and max VDOT values
    func getVDOTRange() -> (min: Int, max: Int) {
        return (min: 25, max: 60)
    }

    /// Estimates pace for a VDOT between table values using linear interpolation
    /// - Parameters:
    ///   - vdot: VDOT value (doesn't need to be exact table value)
    ///   - zone: Training zone
    /// - Returns: Estimated pace in mm:ss format, or nil if VDOT out of range
    func getInterpolatedPace(vdot: Double, zone: PaceZone) -> String? {
        let vdotInt = Int(vdot)
        let remainder = vdot - Double(vdotInt)

        // If exact match or no interpolation needed, return direct lookup
        guard remainder > 0, vdotInt < 60 else {
            return getPace(vdot: vdotInt, zone: zone)
        }

        // Get paces for interpolation
        guard let lowerPaces = paceTable[vdotInt],
              let upperPaces = paceTable[vdotInt + 1],
              let lowerPace = lowerPaces[zone],
              let upperPace = upperPaces[zone] else {
            return nil
        }

        // Convert pace strings to seconds, interpolate, convert back
        guard let lowerSeconds = paceStringToSeconds(lowerPace),
              let upperSeconds = paceStringToSeconds(upperPace) else {
            return nil
        }

        let interpolatedSeconds = Double(lowerSeconds) * (1 - remainder) + Double(upperSeconds) * remainder
        return secondsToPaceString(Int(interpolatedSeconds))
    }

    /// Converts pace string (mm:ss) to total seconds
    private func paceStringToSeconds(_ paceString: String) -> Int? {
        let components = paceString.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2 else { return nil }
        return components[0] * 60 + components[1]
    }

    /// Converts seconds to pace string (mm:ss format)
    private func secondsToPaceString(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

// Re-export PaceZone for convenience
nonisolated enum PaceZone: String, Codable, Hashable, Sendable {
    case easy
    case tempo
    case interval
    case race5k = "race_5k"
    case recovery
}

import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    private let defaults = UserDefaults.standard

    var soundEnabled: Bool {
        get { defaults.object(forKey: "sound") == nil ? true : defaults.bool(forKey: "sound") }
        set { defaults.set(newValue, forKey: "sound") }
    }
    var vibrationEnabled: Bool {
        get { defaults.object(forKey: "vibration") == nil ? true : defaults.bool(forKey: "vibration") }
        set { defaults.set(newValue, forKey: "vibration") }
    }
    var animationsEnabled: Bool {
        get { defaults.object(forKey: "animations") == nil ? true : defaults.bool(forKey: "animations") }
        set { defaults.set(newValue, forKey: "animations") }
    }
}

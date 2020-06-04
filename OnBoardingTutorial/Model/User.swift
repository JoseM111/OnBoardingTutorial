import Foundation

struct User {
    // MARK: #Type alias for UserKeys
    typealias u = UserKeys

    // MARK: _@Properties
    let email: String
    let fullName: String
    var  hasSeenOnboarding: Bool
    let uid: String

    init(uid: String, dict: [String : Any]) {
        self.uid = uid

        self.email = dict[u.EmailKey] as? String ?? ""
        self.fullName = dict[u.FullNameKey] as? String ?? ""
        self.hasSeenOnboarding = dict[u.HasSeenOBKey] as? Bool ?? false
    }

    // MARK: #Secondary init
    init(dict: [String : Any]) {
        self.uid = dict[u.UIDKey] as? String ?? ""
        self.email = dict[u.EmailKey] as? String ?? ""
        self.fullName = dict[u.FullNameKey] as? String ?? ""
        self.hasSeenOnboarding = dict[u.HasSeenOBKey] as? Bool ?? false
    }
}

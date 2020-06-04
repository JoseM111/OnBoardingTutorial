import Foundation
import Firebase

// MARK: Constant Strings

let MSG_METRIC = "Metrics"
let MSG_DASHBOARD = "Dashboard"
let MSG_NOTIFICATIONS = "Get Notified"
let MSG_ONBOARDING_METRICS = "Lorem ipsum dolor sit amet, ullum sententiae te duo, ea nihil populo qui. Te sea quot novum, in velit volutpat eum. Mel cu justo incorrupte. "
let MSG_ONBOARDING_NOTIFICATIONS = "場献号覧長放税港尿書作何子反慶帯人知聞稿。歩指後去中断察施草民人申方直葉職載。"
let MSG_ONBOARDING_DASHBOARD = "دّفاع واندونيسيا،. ثم هناك إحتار ولم, ان الدول بينما اليابان، أسر, ان قررت شاسعة هذا."

let USERS: String = "users"
let DATABASE_DB_REF: DatabaseReference = Database.database().reference()
let REF_USERS: DatabaseReference = DATABASE_DB_REF.child(USERS)
let MSG_RESET_PWD_LINK_SENT: String = "DEBUG: EMAIL VERIFIED 📩\n[SUCCESS] sent reset link..."
let FIRESTORE_FS_COLLECTION: CollectionReference = Firestore.firestore().collection(_: USERS)

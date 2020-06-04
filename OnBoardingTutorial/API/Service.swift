import UIKit
import Firebase
import GoogleSignIn

/*-------------------------------------------------------
 All API Code goes in this file
 -------------------------------------------------------*/

struct Service {
    // MARK: #Keys type aliases
    typealias u = UserKeys
    typealias DBCompletion = (Error?, DatabaseReference) -> Void
    typealias FireStoreCompletion = (Error?) -> Void

    // MARK: _@Service methods
    /**©------------------------------------------------------------------------------©*/
    static func logUserInWith(email: String, pwd: String, completion: AuthDataResultCallback?) {
        
        Auth.auth().signIn(withEmail: email, password: pwd, completion: completion)
    }

    // MARK: #registerUserWithFirebase()
    static func registerUserWithFirebase(email: String, pwd: String, fullName: String, completion: @escaping DBCompletion) {
        
        // MARK: _@Creating a user to add to firebase
        /**©---------------------------------------------©*/
        Auth.auth().createUser(withEmail: email, password: pwd) { (result, error) in
            // - Handling error
            if let error = error {
                return completion(error, REF_USERS)
            }
            // - Providing a User id for the new created user
            guard let uid = result?.user.uid else { return }
            
            // MARK: - Key & values for the created User
            let valueDict: [String: Any] = [
                u.UIDKey : uid, u.EmailKey : email, u.PWKey : pwd,
                u.FullNameKey : fullName, u.HasSeenOBKey : false
            ]
            
            // - Adding the new User to firebase with id & key : values
            REF_USERS.child(uid).updateChildValues(valueDict, withCompletionBlock: completion)
            printf("Successfully created user in [FIREBASE]...")
        }
        /**©---------------------------------------------©*/
    }

    // MARK: #registerUserWithFireStore()
    static func registerUserWithFireStore(email: String, pwd: String, fullName: String, completion: @escaping FireStoreCompletion) {

        // MARK: _@Creating a user to add to firebase
        /**©---------------------------------------------©*/
        Auth.auth().createUser(withEmail: email, password: pwd) { (result, error) in
            // - Handling error
            if let error = error {
                return completion(error)
            }
            // - Providing a User id for the new created user
            guard let uid = result?.user.uid else { return }

            // MARK: - Key & values for the created User
            let valueDict: [String: Any] = [
                u.UIDKey : uid, u.EmailKey : email, u.PWKey : pwd,
                u.FullNameKey : fullName, u.HasSeenOBKey : false
            ]

            // - Adding the new User to fireStore with id & key : values
            FIRESTORE_FS_COLLECTION.document(_: uid).setData(valueDict, completion: completion)
            printf("Successfully created user in [FIREBASE]...")
        }
        /**©---------------------------------------------©*/
    }
    
    /*------------------------------------------------------
     didSignInUser user: GIDGoogleUser⬇
     -------------------------------------------------------
     This class represents a user ⬆ account.
     -------------------------------------------------------*/
    static func signInWithGoogle(didSignInUser user: GIDGoogleUser, completion: @escaping DBCompletion) {
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider
            .credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        // MARK: _@Signing in user with google authorization
        /**©---------------------------------------------©*/
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                printf("Failed to sign in with google..-->>\(error.localizedDescription) in function: \(#function)")
                return completion(error, REF_USERS)
            }
            
            // - Providing a User id for the new created user
            guard let uid = result?.user.uid else { return }

            // MARK: #Making an API call
            /*-------------------------------------------------------
              If -->> the data does not exist then create it
              else-->> then complete with error of id --> uid
              because the user already exist...
              -------------------------------------------------------*/
            REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapShot) in

                if !snapShot.exists() {
                    printf("DEBUG: User does not exist..-->> Creating user account...")
                    // signing in the user based on there google info
                    guard let email = result?.user.email,
                          let fullName = result?.user.displayName else { return }

                    // - Key & values for the created User
                    let valueDict: [String: Any] = [
                        u.UIDKey : uid, u.EmailKey : email,
                        u.FullNameKey : fullName, u.HasSeenOBKey : false
                    ]

                    // - Adding the new User to firebase with id & key : values
                    REF_USERS.child(uid).updateChildValues(valueDict, withCompletionBlock: completion)
                    printf("Successfully signed in with google...")

                } else {
                    printf("DEBUG: [ERROR] User already exist...")
                    completion(error, REF_USERS.child(uid))
                }
            }
            /**©-------------------------------------------©*/
        }
        /**©---------------------------------------------©*/
    }

    static func fetchUser(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapShot) in

            let uid = snapShot.key
            guard let dict = snapShot.value as? [String: Any] else { return }

            let user = User(uid: uid, dict: dict)
            completion(user)
        }
    }

    static func fetchUserWithFirestore(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        FIRESTORE_FS_COLLECTION.document(uid).getDocument { (snapShot, _) in
            guard let snapShotDict = snapShot?.data() else { return }
            let user = User(dict: snapShotDict)
            completion(user)
        }
    }

    // Sets the hasSeenOnboarding to `true` by uid
    static func updateUserHasSeenOB(completion: @escaping DBCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(uid).child(u.HasSeenOBKey).setValue(true, withCompletionBlock: completion)
    }

    // Sets the hasSeenOnboarding to `true` by uid
    static func updateUserHasSeenOBFirestore(completion: @escaping FireStoreCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data = [u.HasSeenOBKey : true]

        // NOTE: setData `overwrites` everything & updateData `updates` everything
        FIRESTORE_FS_COLLECTION.document(uid).updateData(data, completion: completion)
    }

    /*-------------------------------------------------------
      SendPasswordResetCallback:
      block invoked when sending a password reset email.
      error Optionally; if an error occurs, this is the NSError
      object that describes the problem. Set to nil otherwise.
      -------------------------------------------------------*/
    static func resetPWD(forEmail email: String, completion: SendPasswordResetCallback?) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
    /**©------------------------------------------------------------------------------©*/
}// END OF STRUCT

import Foundation
import paper_onboarding

struct OBViewModel {
    
    let itemCount: Int
    
    init(itemCount: Int) {
        self.itemCount = itemCount
    }
    
    func shouldShowGetStartedBtnFor(index: Int) -> Bool {
        index == itemCount - 1 ? true : false
    }
}

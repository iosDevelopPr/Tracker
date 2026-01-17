
import UIKit

extension UIApplication {
    var windows: [UIWindow] {
        connectedScenes
            .flatMap({ ($0 as? UIWindowScene)?.windows ?? [] })
    }
}

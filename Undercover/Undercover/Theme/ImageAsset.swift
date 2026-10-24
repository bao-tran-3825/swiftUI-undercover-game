//
//  ImageAsset.swift
//  Undercover
//
//  Central list of image asset names so no raw strings are scattered around the app.
//  Each case's raw value must match an image set in Assets.xcassets.
//

import SwiftUI

enum ImageAsset: String {
    case civilian = "civilianImage"
    case undercover = "undercoverImage"
    case pig = "pigImage"
    /// Artwork shown on the back of the reveal card.
    case cardBack = "background1"
    /// Full-screen artwork for the discussion rounds.
    case discussionBackground = "background2"

    /// The SwiftUI `Image` for this asset.
    var image: Image { Image(rawValue) }

    /// Whether the asset actually exists in the catalog (useful for fallbacks).
    var exists: Bool { UIImage(named: rawValue) != nil }
}

extension UIImage {
    /// The app's primary icon, read from the bundle at runtime.
    static var appIcon: UIImage? {
        guard let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primary = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let files = primary["CFBundleIconFiles"] as? [String],
              let name = files.last else { return nil }
        return UIImage(named: name)
    }
}

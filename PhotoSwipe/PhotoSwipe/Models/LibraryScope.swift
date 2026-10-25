import Foundation
import Photos

/// Which part of the Photos library the app works on. iCloud Shared Library
/// assets live in the same PhotoKit result set as personal ones, so this is
/// applied as a post-fetch filter (see `PhotoLibraryService.isInSharedLibrary`).
enum LibraryScope: String, CaseIterable {
    case personal   // only photos in the user's own library
    case all        // personal + iCloud Shared Library

    var title: String {
        switch self {
        case .personal: return "Personal"
        case .all: return "Personal + Shared"
        }
    }

    private static let key = "libraryScope"

    static func load(from defaults: UserDefaults = .standard) -> LibraryScope {
        defaults.string(forKey: key).flatMap(LibraryScope.init(rawValue:)) ?? .personal
    }

    func save(to defaults: UserDefaults = .standard) {
        defaults.set(rawValue, forKey: LibraryScope.key)
    }
}

/// Result of one full library pass, already split by scope.
struct LibrarySnapshot {
    var personal: [PHAsset] = []
    var shared: [PHAsset] = []
    var everything: [PHAsset] = []

    func images(for scope: LibraryScope) -> [PHAsset] {
        scope == .personal ? personal : everything
    }
}

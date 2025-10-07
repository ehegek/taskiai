import UIKit

enum ImageStore {
    private static var folderUrl: URL = {
        let fm = FileManager.default
        let url = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("TaskImages", isDirectory: true)
        if !fm.fileExists(atPath: url.path) {
            try? fm.createDirectory(at: url, withIntermediateDirectories: true)
        }
        return url
    }()

    static func save(_ image: UIImage, id: UUID = UUID(), compressionQuality: CGFloat = 0.9) -> UUID? {
        guard let data = image.jpegData(compressionQuality: compressionQuality) else { return nil }
        let fileUrl = folderUrl.appendingPathComponent("\(id.uuidString).jpg")
        do {
            try data.write(to: fileUrl, options: .atomic)
            return id
        } catch {
            print("[ImageStore] save error: \(error)")
            return nil
        }
    }

    static func load(_ id: UUID) -> UIImage? {
        let fileUrl = folderUrl.appendingPathComponent("\(id.uuidString).jpg")
        guard let data = try? Data(contentsOf: fileUrl) else { return nil }
        return UIImage(data: data)
    }

    static func delete(_ id: UUID) {
        let fileUrl = folderUrl.appendingPathComponent("\(id.uuidString).jpg")
        try? FileManager.default.removeItem(at: fileUrl)
    }
}

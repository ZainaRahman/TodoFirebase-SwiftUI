import Foundation
import FirebaseFirestore

struct TaskItem: Codable, Identifiable {
    var id = UUID().uuidString
    var text: String
    var isDone: Bool = false
}


struct Note: Codable, Identifiable {
    @DocumentID var id: String?   
    var title: String
    var tasks: [TaskItem]
    var createdAt: Date = Date()
}

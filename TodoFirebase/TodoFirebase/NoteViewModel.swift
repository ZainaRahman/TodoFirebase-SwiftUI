import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
class NoteViewModel: ObservableObject {
    @Published var notes: [Note] = []

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    private var notesRef: CollectionReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return db.collection("users").document(uid).collection("notes")
    }


    func startListening() {
        listener?.remove()
        listener = notesRef?
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self?.notes = documents.compactMap { try? $0.data(as: Note.self) }
            }
    }


    func addNote(title: String, tasks: [TaskItem]) {
        let note = Note(title: title, tasks: tasks)
        try? notesRef?.addDocument(from: note)
    }

    func toggleTask(note: Note, task: TaskItem) {
        guard let noteID = note.id,
              let index = note.tasks.firstIndex(where: { $0.id == task.id }) else { return }
        var updated = note
        updated.tasks[index].isDone.toggle()
        try? notesRef?.document(noteID).setData(from: updated)
    }


    func deleteNote(_ note: Note) {
        guard let noteID = note.id else { return }
        notesRef?.document(noteID).delete()
    }
}

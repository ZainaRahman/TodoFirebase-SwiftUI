import SwiftUI


enum Route: Hashable {
    case addNote
}

struct NoteView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var noteVM = NoteViewModel()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                if noteVM.notes.isEmpty {
                    Text("No plans yet. Tap + to add one.")
                        .foregroundStyle(.secondary)
                }

                ForEach(noteVM.notes) { note in
                    Section {
                        ForEach(note.tasks) { task in
                            CheckboxRow(text: task.text, isDone: task.isDone) {
                                noteVM.toggleTask(note: note, task: task)
                            }
                        }
                    } header: {
                        HStack {
                            Text(note.title)
                                .font(.headline)
                                .textCase(nil)
                            Spacer()
                            Button(role: .destructive) {
                                noteVM.deleteNote(note)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
            }
            .navigationTitle("My Plans")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Log Out") { authVM.signOut() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: Route.addNote) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .addNote:
                    AddNoteView(noteVM: noteVM, path: $path)
                }
            }
        }
        .onAppear {
            noteVM.startListening()
        }
    }
}


struct CheckboxRow: View {
    let text: String
    let isDone: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: isDone ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundStyle(isDone ? Color.green : Color.gray)
                Text(text)
                    .strikethrough(isDone)
                    .foregroundStyle(isDone ? .secondary : .primary)
                Spacer()
            }
            .contentShape(Rectangle())  
        }
        .buttonStyle(.plain)
    }
}

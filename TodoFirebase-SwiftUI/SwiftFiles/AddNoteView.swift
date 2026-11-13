import SwiftUI

struct AddNoteView: View {
    @ObservedObject var noteVM: NoteViewModel
    @Binding var path: NavigationPath      // used to go back after saving

    @State private var title = ""
    @State private var newTask = ""
    @State private var tasks: [TaskItem] = []

    var body: some View {
        VStack(spacing: 16) {
            // Heading of this to-do list
            TextField("Plan heading (e.g. Exam Prep)", text: $title)
                .font(.title2.bold())
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))

            // Input + add button
            HStack {
                TextField("Add a task", text: $newTask)
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4)))

                Button {
                    addTask()
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                        .padding(12)
                        .background(Circle().fill(Color.blue))
                }
                .disabled(newTask.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            // Tasks added so far (swipe left to delete)
            List {
                ForEach($tasks) { $task in
                    CheckboxRow(text: task.text, isDone: task.isDone) {
                        task.isDone.toggle()
                    }
                }
                .onDelete { tasks.remove(atOffsets: $0) }
            }
            .listStyle(.plain)

            Spacer()

            Button {
                save()
            } label: {
                Text("Save Plan")
                    .bold()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
            }
            .disabled(title.isEmpty || tasks.isEmpty)
        }
        .padding()
        .navigationTitle("New Plan")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func addTask() {
        let text = newTask.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        tasks.append(TaskItem(text: text))
        newTask = ""
    }

    private func save() {
        noteVM.addNote(title: title, tasks: tasks)
        path.removeLast()          // go back to NoteView
    }
}

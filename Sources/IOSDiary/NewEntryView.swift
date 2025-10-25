import SwiftUI

struct NewEntryView: View {
    @State private var title = ""
    @State private var content = ""
    let onSave: (DiaryEntry) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Entry Details")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                }
            }
            .navigationTitle("New Entry")
            .navigationBarItems(
                leading: Button("Cancel") {
                    // Handle cancel
                },
                trailing: Button("Save") {
                    let newEntry = DiaryEntry(title: title, content: content)
                    onSave(newEntry)
                }
                .disabled(title.isEmpty || content.isEmpty)
            )
        }
    }
}

struct NewEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NewEntryView { _ in }
    }
}
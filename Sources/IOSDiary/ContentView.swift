import SwiftUI

struct ContentView: View {
    @State private var diaryEntries: [DiaryEntry] = []
    @State private var showingNewEntry = false
    
    var body: some View {
        NavigationView {
            List(diaryEntries) { entry in
                DiaryEntryRow(entry: entry)
            }
            .navigationTitle("My Diary")
            .navigationBarItems(trailing: 
                Button("New Entry") {
                    showingNewEntry = true
                }
            )
            .sheet(isPresented: $showingNewEntry) {
                NewEntryView { newEntry in
                    diaryEntries.append(newEntry)
                    showingNewEntry = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
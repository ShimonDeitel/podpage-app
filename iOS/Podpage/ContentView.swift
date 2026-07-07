import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showAddSheet = false
    @State private var showPaywall = false
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.entries) { entry in
                        EntryRow(entry: entry)
                            .listRowBackground(Theme.background)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
            .navigationTitle("Podpage - Podcast Log")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showAddSheet = true
                        } else {
                            showPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddEntrySheet()
                    .environmentObject(store)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(store)
                    .environmentObject(purchases)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
                    .environmentObject(purchases)
            }
        }
        .tint(Theme.accent)
    }
}

struct EntryRow: View {
    let entry: EpisodeEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.date, style: .date)
                .font(Theme.captionFont)
                .foregroundStyle(Theme.accentSecondary)
            Text("\(entry.show) \(entry.episodeTitle)")
                .font(Theme.bodyFont)
                .foregroundStyle(Theme.foreground)
            if !entry.notes.isEmpty {
                Text(entry.notes)
                    .font(Theme.captionFont)
                    .foregroundStyle(Theme.foreground.opacity(0.7))
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddEntrySheet: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) var dismiss
    @State private var date = Date()
    @State private var show: String = ""
    @State private var episodeTitle: String = ""
    @State private var ratingText: String = ""
    @State private var notes: String = ""
    @FocusState private var focusedField: Bool

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Show", text: $show)
                    .focused($focusedField)
                TextField("EpisodeTitle", text: $episodeTitle)
                    .focused($focusedField)
                TextField("Rating (1-5)", text: $ratingText)
                    .keyboardType(.numberPad)
                    .focused($focusedField)
                TextField("Notes", text: $notes)
                    .focused($focusedField)
            }
            .navigationTitle("Add Episode")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelAddButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                    .accessibilityIdentifier("saveEntryButton")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = false
            }
        }
    }

    private func save() {
        let entry = EpisodeEntry(
            date: date,
            show: show,
            episodeTitle: episodeTitle,
            rating: Int(ratingText) ?? 0,
            notes: notes
        )
        store.add(entry)
    }
}

import Foundation

struct EpisodeEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var show: String
    var episodeTitle: String
    var rating: Int
    var notes: String

    init(id: UUID = UUID(), date: Date = Date(), show: String = "", episodeTitle: String = "", rating: Int = 0, notes: String = "") {
        self.id = id
        self.date = date
        self.show = show
        self.episodeTitle = episodeTitle
        self.rating = rating
        self.notes = notes
    }
}

struct AppSettings: Codable, Equatable {
    var remindersEnabled: Bool = true
    var metricUnits: Bool = false
    var includeInStreak: Bool = true
}

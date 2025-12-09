import SwiftUI

struct DiaryView: View {
    @State private var homework: [String] = [
        "Математика – №5 есеп",
        "Ағылшын – эссе жазу"
    ]

    @State private var notes: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Күнделік")
                    .font(.title2).bold()

                // HOMEWORK LIST
                VStack(alignment: .leading, spacing: 8) {
                    Text("Үй тапсырмалары")
                        .font(.headline)

                    ForEach(homework, id: \.self) { item in
                        Text("• \(item)")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                }

                // TEACHER NOTES
                VStack(alignment: .leading, spacing: 8) {
                    Text("Мұғалімнің жазбасы")
                        .font(.headline)

                    TextEditor(text: $notes)
                        .padding()
                        .frame(height: 120)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
        }
    }
}

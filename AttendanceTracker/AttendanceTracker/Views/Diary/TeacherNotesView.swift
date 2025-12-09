//
//  TeacherNotesView.swift
//  AttendanceTracker
//
//  Created by Nazerke Bagdatkyzy on 09.12.2025.
//

import SwiftUI

struct TeacherNotesView: View {
    @State private var notes: String = "Good progress this week. Needs improvement in reading tasks."

    var body: some View {
        VStack(alignment: .leading) {
            Text("Teacher Notes")
                .font(.headline)
            TextEditor(text: $notes)
                .frame(height: 200)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
            Spacer()
        }
        .padding()
        .navigationTitle("Notes")
    }
}

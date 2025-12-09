//
//  GradesView.swift
//  AttendanceTracker
//
//  Created by Nazerke Bagdatkyzy on 09.12.2025.
//

import SwiftUI

struct GradeItem: Identifiable {
    let id = UUID()
    let subject: String
    let grade: String
}

struct GradesView: View {
    let grades = [
        GradeItem(subject: "Math", grade: "A"),
        GradeItem(subject: "English", grade: "B+"),
        GradeItem(subject: "Physics", grade: "A-")
    ]
    
    var body: some View {
        List(grades) { item in
            HStack {
                Text(item.subject)
                Spacer()
                Text(item.grade)
                    .bold()
                    .foregroundColor(.blue)
            }
        }
        .navigationTitle("Grades")
    }
}

//
//  HomeworkListView.swift
//  AttendanceTracker
//
//  Created by Nazerke Bagdatkyzy on 09.12.2025.
//

import SwiftUI

struct Homework: Identifiable {
    let id = UUID()
    let subject: String
    let task: String
    let deadline: String
    var isDone: Bool
}

struct HomeworkListView: View {
    @State private var homeworkList = [
        Homework(subject: "Math", task: "Solve 10 equations", deadline: "Tomorrow", isDone: false),
        Homework(subject: "English", task: "Write an essay", deadline: "Friday", isDone: true)
    ]
    
    var body: some View {
        List {
            ForEach($homeworkList) { $hw in
                HStack {
                    VStack(alignment: .leading) {
                        Text(hw.subject).font(.headline)
                        Text(hw.task).font(.subheadline)
                        Text("📅 \(hw.deadline)").font(.caption)
                    }
                    Spacer()
                    Button(action: { hw.isDone.toggle() }) {
                        Image(systemName: hw.isDone ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(hw.isDone ? .green : .gray)
                            .font(.title2)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Homework")
    }
}

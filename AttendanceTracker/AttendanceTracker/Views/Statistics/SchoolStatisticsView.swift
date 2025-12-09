import SwiftUI
import CoreData

struct SchoolStatisticsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var school: School

    @State private var classStats: [(classRoom: ClassRoom, percent: Double)] = []
    @State private var teacherStats: [(teacher: Teacher, percent: Double)] = []
    @State private var schoolPercent: Double = 0.0

    @State private var lowAttendanceStudents: [(student: Student, percent: Double)] = []

    var body: some View {

        // ---- Мектеп атын қауіпсіз түрде шығару ----
        let schoolName = (school.value(forKey: "name") as? String) ?? "Мектеп"

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // -------- Мектеп аты --------
                Text(schoolName)
                    .font(.largeTitle)
                    .bold()

                // -------- Жалпы мектеп пайызы --------
                VStack(alignment: .leading, spacing: 10) {
                    Text("Жалпы қатысу пайызы")
                        .font(.headline)

                    Text(String(format: "%.1f%%", schoolPercent))
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.blue)

                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                // -------- Сыныптар рейтингі --------
                VStack(alignment: .leading, spacing: 10) {
                    Text("Сыныптар бойынша рейтинг")
                        .font(.headline)

                    ForEach(classStats, id: \.classRoom.objectID) { item in
                        HStack {
                            Text(item.classRoom.name ?? "Сынып")
                            Spacer()
                            Text(String(format: "%.1f%%", item.percent))
                                .bold()
                        }
                        .padding(10)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                    }

                    if classStats.isEmpty {
                        Text("Статистика жоқ")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                // -------- Мұғалімдер статистикасы --------
                VStack(alignment: .leading, spacing: 10) {
                    Text("Мұғалімдердің орташа статистикасы")
                        .font(.headline)

                    ForEach(teacherStats, id: \.teacher.objectID) { item in
                        HStack {
                            Text(item.teacher.name ?? "Мұғалім")
                            Spacer()
                            Text(String(format: "%.1f%%", item.percent))
                                .bold()
                        }
                        .padding(10)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                    }

                    if teacherStats.isEmpty {
                        Text("Мұғалімдер жоқ немесе статистика бос")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)



                // -------- Төмен қатысуы бар оқушылар --------
                VStack(alignment: .leading, spacing: 10) {
                    Text("Төмен қатысуы бар оқушылар (50%-дан төмен)")
                        .font(.headline)

                    ForEach(lowAttendanceStudents, id: \.student.objectID) { item in
                        HStack {
                            Text(item.student.name ?? "Оқушы")
                            Spacer()
                            Text(String(format: "%.1f%%", item.percent))
                                .foregroundColor(.red)
                                .bold()
                        }
                        .padding(10)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                    }

                    if lowAttendanceStudents.isEmpty {
                        Text("Барлық оқушылардың қатысуы қалыпты.")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Мектеп статистикасы")
        .onAppear(perform: computeSchoolStats)
    }



    // =====================================================
    //               МЕКТЕП СТАТИСТИКА ЕСЕПТЕУ
    // =====================================================
    private func computeSchoolStats() {

        let classes = (school.classes as? Set<ClassRoom>) ?? []

        var totalPresent = 0
        var totalPossible = 0

        var perClass: [(ClassRoom, Double)] = []
        var perTeacherDict: [Teacher: [Double]] = [:]
        var lowList: [(Student, Double)] = []

        for classRoom in classes {

            let students = (classRoom.students as? Set<Student>) ?? []
            if students.isEmpty { continue }

            let req: NSFetchRequest<Attendance> = Attendance.fetchRequest()
            req.predicate = NSPredicate(format: "student.classRoom == %@", classRoom)

            do {
                let records = try viewContext.fetch(req)

                let days = Set(records.compactMap { Calendar.current.startOfDay(for: $0.date ?? Date()) })
                let totalDays = days.count
                if totalDays == 0 { continue }

                let classTotalPossible = totalDays * students.count
                let classPresent = records.filter { $0.status == "present" }.count

                let classPercent = Double(classPresent) / Double(classTotalPossible) * 100
                perClass.append((classRoom, classPercent))

                totalPresent += classPresent
                totalPossible += classTotalPossible

                if let t = classRoom.teacher {
                    perTeacherDict[t, default: []].append(classPercent)
                }

                // -------- Оқушылар статистикасы --------
                for student in students {
                    let reqS: NSFetchRequest<Attendance> = Attendance.fetchRequest()
                    reqS.predicate = NSPredicate(format: "student == %@", student)

                    let sRecords = try viewContext.fetch(reqS)
                    if sRecords.isEmpty { continue }

                    let present = sRecords.filter { $0.status == "present" }.count
                    let total = sRecords.count

                    let percent = Double(present) / Double(total) * 100
                    if percent < 50 {
                        lowList.append((student, percent))
                    }
                }

            } catch {
                print("Fetch error:", error)
            }
        }

        classStats = perClass.sorted { $0.1 > $1.1 }
        schoolPercent = totalPossible > 0 ? (Double(totalPresent) / Double(totalPossible)) * 100 : 0

        teacherStats = perTeacherDict.map { (teacher, values) in
            (teacher, values.reduce(0, +) / Double(values.count))
        }.sorted { $0.1 > $1.1 }

        lowAttendanceStudents = lowList.sorted { $0.1 < $1.1 }
    }
}


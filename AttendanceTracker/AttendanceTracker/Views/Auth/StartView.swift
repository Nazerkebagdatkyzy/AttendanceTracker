//
//  StartView.swift
//  AttendanceTracker
//
//  Created by Nazerke Bagdatkyzy on 05.12.2025.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                NavigationLink(destination: TeacherLoginView()) {
                    Text("Мұғалім ретінде кіру")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }

                NavigationLink(destination: AdminLoginView()) {
                    Text("Админ ретінде кіру")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }

                NavigationLink(destination: TeacherRegisterView()) {
                    Text("Тіркелу (мұғалім)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }

                NavigationLink(destination: AdminRegisterView()) {
                    Text("Админ тіркелу")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }

                Spacer()
            }
            .padding()
        }
    }
}


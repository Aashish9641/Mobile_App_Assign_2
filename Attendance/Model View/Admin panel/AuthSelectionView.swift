//
//  AuthSelectionView.swift
//  Attendance
//
//  Created by NAAMI COLLEGE on 31/03/2025.
//

import UIKit
import SwiftUI

struct AuthSelectionView: View {
    @Binding var isAdminLoggedIn: Bool
    @Binding var isStudentLoggedIn: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("University of GraceTech")
                    .font(.title)
                    .padding(.bottom, 40)
                
                NavigationLink(destination: AdminLoginScreen(isAdminLoggedIn: $isAdminLoggedIn)) {
                    Text("Admin Login")
                        .frame(width: 200)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: StudentLoginScreen(isStudentLoggedIn: $isStudentLoggedIn)) {
                    Text("Student Login")
                        .frame(width: 200)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

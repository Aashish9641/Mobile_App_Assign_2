// MARK: - InfoRow.swift
import SwiftUI

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
                .foregroundColor(.purple)
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
}

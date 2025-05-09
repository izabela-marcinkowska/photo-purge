//
//  MonthSelectionView.swift
//  Photo Purge
//
//  Created by Izabela Marcinkowska on 2025-05-02.
//

import SwiftUI


struct MonthSelectionView: View {
    @State private var selectedDate = Date()
    @State private var showPhotoReview = false
    
    private func formattedMonth(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Select a month")
                .font(.title)
                .fontWeight(.bold)
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .transformEffect(.init(scaleX: 1.1, y: 1.1))
                .padding()
            
            Text("\(formattedMonth(from: selectedDate))")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
            
            Spacer()
            
            NavigationLink {
                PhotoReviewView(selectedMonth: selectedDate)
            } label: {
                Text("Review Photos")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom, 40)
        }
        .padding()
        .navigationTitle("Month Selection")
    }
}

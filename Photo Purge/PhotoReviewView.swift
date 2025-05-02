//
//  PhotoReviewView.swift
//  Photo Purge
//
//  Created by Izabela Marcinkowska on 2025-05-02.
//

import SwiftUI

struct PhotoReviewView: View {
    var selectedMonth: Date
    
    private func formattedMonth(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//
//  AppScreen.swift
//  Photo Purge
//
//  Created by Izabela Marcinkowska on 2025-05-14.
//

import Foundation
import SwiftUI

enum AppScreen {
    case home
    case monthSelection
    case photoReview
    case deleteSummary
}

class AppViewModel: ObservableObject {
    @Published var currentScreen: AppScreen = .home
    @Published var selectedMonth: Date = Date()
    
    func goToHome() {
        currentScreen = .home
    }
    
    func goToMonthSelection() {
        currentScreen = .monthSelection
    }
    
    func goToPhotoReview(month: Date) {
        selectedMonth = month
        currentScreen = .photoReview
    }
    
    func goToDeleteSummary() {
        currentScreen = .deleteSummary
    }
    
}

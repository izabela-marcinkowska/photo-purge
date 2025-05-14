//
//  MainView.swift
//  Photo Purge
//
//  Created by Izabela Marcinkowska on 2025-05-14.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var photoLibraryManager: PhotoLibraryManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch appViewModel.currentScreen {
                case .home:
                    ContentView()
                case .monthSelection:
                    MonthSelectionView()
                case .photoReview:
                    PhotoReviewView(selectedMonth: appViewModel.selectedMonth)
                case .deleteSummary:
                    DeleteSummaryView()
                }
            }
        }
    }
}

#Preview {
    MainView()
}

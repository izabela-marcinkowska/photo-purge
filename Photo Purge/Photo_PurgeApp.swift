//
//  Photo_PurgeApp.swift
//  Photo Purge
//
//  Created by Izabela Marcinkowska on 2025-05-02.
//

import SwiftUI

@main
struct Photo_PurgeApp: App {
    @StateObject private var photoLibraryManager = PhotoLibraryManager()
    @StateObject private var photoAssetManager = PhotoAssetManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(photoLibraryManager)
                .environmentObject(photoAssetManager)
        }
    }
}

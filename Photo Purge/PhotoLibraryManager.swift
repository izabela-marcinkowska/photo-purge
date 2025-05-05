//
//  PhotoLibraryManager.swift
//  Photo Purge
//
//  Created by Izabela Marcinkowska on 2025-05-05.
//

import Foundation
import Photos
import SwiftUI

class PhotoLibraryManager: ObservableObject {
    @Published var authorizationStatus: PHAuthorizationStatus = .notDetermined
    
    init() {
        checkPermission()
    }
    
    func checkPermission() {
        authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func requestPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                self.authorizationStatus = status
            }
        }
    }
    
    var hasPermission: Bool {
        return authorizationStatus == .authorized || authorizationStatus == .limited
    }
}

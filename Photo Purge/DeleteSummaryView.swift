//
//  DeleteSummaryView.swift
//  Photo Purge
//
//  Created by Izabela Marcinkowska on 2025-05-12.
//

import SwiftUI

struct DeleteSummaryView: View {
    @EnvironmentObject var photoAssetManager: PhotoAssetManager
    @State private var isDeleting = false
    @State private var deleteComplete = false
    @State private var deleteSuccess = false
    @State private var deleteError: Error? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "trash.circle")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Review Summary")
                .font(.title)
                .fontWeight(.bold)
            
            Text("You've marked \(photoAssetManager.assetsToDelete.count) photos for deletion.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            if isDeleting {
                ProgressView("Deleting photos...")
                    .padding()
            } else if deleteComplete {
                if deleteSuccess {
                    VStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Photos successfully deleted!")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    .padding()
                } else if deleteError != nil {
                    VStack(spacing: 10) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.headline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            } else {
                if photoAssetManager.assetsToDelete.count > 0 {
                    Button(action: {
                        deletePhotos()
                    }) {
                        Text("Delete Photos")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Text("This will permanently delete the selected photos from your library")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                } else {
                    Text("You haven't marked any photos for deletion.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            Spacer()
            
        }
        .padding()
        .navigationTitle("Delete summary")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func deletePhotos() {
        isDeleting = true
        
        photoAssetManager.deleteMarkedPhotos { success, error in
            DispatchQueue.main.async {
                isDeleting = false
                deleteComplete = true
                deleteSuccess = success
                deleteError = error
            }
        }
    }
}


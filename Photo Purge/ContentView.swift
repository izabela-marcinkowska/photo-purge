//
//  ContentView.swift
//  Photo Purge
//
//  Created by Izabela Marcinkowska on 2025-05-02.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var photoLibraryManager: PhotoLibraryManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "photo.stack")
                    .imageScale(.large)
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Photo Purge")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Clean up your photo library month by month")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer().frame(height: 20)
                
                if photoLibraryManager.authorizationStatus == .notDetermined {
                    Button(action: {
                        photoLibraryManager.requestPermission()
                    }) {
                        Text("Request Photo Access")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                } else if photoLibraryManager.hasPermission {
                    NavigationLink(destination: MonthSelectionView()) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                } else {
                    Text("Photo Access Denided")
                        .foregroundColor(.red)
                    
                    Button(action: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Open Settings")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Photo Purge")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


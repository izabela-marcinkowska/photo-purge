//
//  ContentView.swift
//  Photo Purge
//
//  Created by Izabela Marcinkowska on 2025-05-02.
//

import SwiftUI

struct ContentView: View {
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
                
                NavigationLink(destination: MonthSelectionView()) {
                    Text("Get started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Photo Purge")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


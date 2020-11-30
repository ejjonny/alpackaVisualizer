//
//  PackingRect.swift
//  alpackaVisualizer
//
//  Created by Ethan John on 1/2/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import SwiftUI

struct PackingRect: View {
    @Binding var objects: [PackableObject]
    var body: some View {
        GeometryReader { proxy in
            ForEach(self.objects.indices, id: \.self) { index in
                return Rectangle()
                    .border(Color.blue)
                    .offset(CGSize(width: self.objects[index].origin.x, height: self.objects[index].origin.y))
                    .frame(width: self.objects[index].width, height: self.objects[index].height)
            }
            .transition(.opacity)
        }
        .clipped()
    }
    
    func randomColor() -> Color {
        Color(red: Double.random(in: 0...255) / 255,
              green: Double.random(in: 0...255) / 255,
              blue: Double.random(in: 0...255) / 255)
    }
}

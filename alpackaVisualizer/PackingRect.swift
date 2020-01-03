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
                    .offset(self.objects[index].origin)
                    .frame(width: self.objects[index].width, height: self.objects[index].height)
                    .animation(.easeInOut)
                    .foregroundColor(self.randomColor())
            }
            .transition(.opacity)
        }
    }
    
    func randomColor() -> Color {
        Color(red: Double.random(in: 0...255) / 255,
              green: Double.random(in: 0...255) / 255,
              blue: Double.random(in: 0...255) / 255)
    }
}

//struct PackingRect_Previews: PreviewProvider {
//    static var previews: some View {
//        PackingRect(objects: [
//            PackableObject(origin: CGPoint(x: 20, y: 20), width: 20, height: 20),
//            PackableObject(origin: CGPoint(x: 40, y: 11), width: 134, height: 40)
//        ])
//    }
//}

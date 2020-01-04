//
//  Home.swift
//  alpackaVisualizer
//
//  Created by Ethan John on 1/2/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import SwiftUI
import Alpacka

struct Home: View {
    @State var width: String = "10"
    @State var widthRandom: Bool = true
    @State var minWidth: String = "1"
    @State var height: String = "10"
    @State var heightRandom: Bool = true
    @State var minHeight: String = "1"
    @State var insertCount: String = "1"
    @State var objects = [PackableObject]()
    @State var overFlow = Int()
    @State var packedObjects = Int()
    @State var time = Double()
    var body: some View {
        VStack {
            Text("Alpacka")
                .font(.largeTitle)
                .fontWeight(.bold)
            HStack {
                Text("Width")
                Spacer()
                Text("Random")
            }
            .padding()
            SizeControl(size: $width, minimum: $minWidth, random: $widthRandom, title: "Width")
            HStack {
                Text("Height")
                Spacer()
                Text("Random")
            }
            .padding()
            SizeControl(size: $height, minimum: $minHeight, random: $heightRandom, title: "Height")
            HStack {
                Text("Insert")
                Spacer()
            }
            .padding()
            HStack {
                TextField("Amount to insert", text: $insertCount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
                Button(action: {
                    self.add()
                }) {
                    Rectangle()
                        .cornerRadius(10)
                        .overlay(Image(systemName: "tray.and.arrow.down").foregroundColor(.white))
                }
                .padding()
                Button(action: {
                    self.pack()
                }) {
                    Rectangle()
                        .cornerRadius(10)
                        .overlay(Image(systemName: "arrow.clockwise").foregroundColor(.white))
                }
                .padding()
                Button(action: {
                    self.objects.removeAll()
                    self.overFlow = 0
                    self.packedObjects = 0
                    self.time = 0
                }) {
                    Rectangle()
                        .cornerRadius(10)
                        .overlay(Image(systemName: "trash").foregroundColor(.white))
                }
                .foregroundColor(.red)
                .padding()
            }
            .frame(height: 80)
            HStack {
                Text("Packed Objects: \(packedObjects)")
                    .font(.system(size: 10))
                Text("Overflow: \(overFlow)")
                    .font(.system(size: 10))
                    .foregroundColor(overFlow > 0 ? .red : Color("textColor"))
                Text("Seconds: \(time)")
                    .font(.system(size: 10))
            }
            PackingRect(objects: $objects)
                .border(Color.black)
                .frame(width: 400, height: 400)
                .background(Color.gray)
                .padding([.leading, .trailing, .bottom], 15)
        }
    }
    
    func add() {
        guard
            let insertCount = Int(insertCount),
            let minHeight = Int(minHeight),
            let height = Int(height),
            let minWidth = Int(minWidth),
            let width = Int(width) else { return }
        guard minHeight <= height,
            minWidth <= width else { return }
        for _ in 1...insertCount {
            let objectHeight = heightRandom ? CGFloat(Int.random(in: minHeight...height)) : CGFloat(height)
            let objectWidth = widthRandom ? CGFloat(Int.random(in: minWidth...width)) : CGFloat(width)
            objects.append(PackableObject(origin: CGPoint.zero, width: objectWidth, height: objectHeight))
        }
        pack()
    }
    
    func pack() {
        let startDate = Date()
        Alpacka.Packer().pack(objects, origin: \.origin, in: CGSize(width: 400, height: 400)) { result in
            self.time = abs(startDate.timeIntervalSinceNow)
            switch result {
            case let .overFlow(packed, overFlow: overFlow):
                self.objects = packed
                self.overFlow = overFlow.count
                self.packedObjects = packed.count
            case let .success(packed):
                self.objects = packed
                self.packedObjects = packed.count
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

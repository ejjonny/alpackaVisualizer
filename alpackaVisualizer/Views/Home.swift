//
//  Home.swift
//  alpackaVisualizer
//
//  Created by Ethan John on 1/2/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import SwiftUI
import Alpacka
import Combine

struct Home: View {
    @State var width: String = "100"
    @State var widthRandom: Bool = true
    @State var minWidth: String = "10"
    @State var height: String = "100"
    @State var heightRandom: Bool = true
    @State var minHeight: String = "10"
    @State var insertCount: String = "100"
    @State var objects = [PackableObject]()
    @State var packedObjects = [PackableObject]()
    @State var time = Double()
    @State var cancellables = Set<AnyCancellable>()
    var body: some View {
        VStack {
            HStack {
                Image("alpackaLogo")
                    .resizable()
                    .aspectRatio(nil, contentMode: .fit)
                Text("Alpacka")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: true, vertical: false)
            }
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
                    self.packedObjects.removeAll()
                    self.clearMetrics()
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
                Text("Packed Objects: \(packedObjects.count)")
                    .font(.system(size: 10))
                Text("Overflow: \(objects.count - packedObjects.count)")
                    .font(.system(size: 10))
                    .foregroundColor(objects.count - packedObjects.count > 0 ? .red : Color("textColor"))
                Text("Seconds: \(time)")
                    .font(.system(size: 10))
            }
            PackingRect(objects: $packedObjects)
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
        clearMetrics()
        Alpacka.pack(objects, origin: \.origin, in: .init(w: 400, h: 400))
            .sink { result in
                self.time = abs(startDate.timeIntervalSinceNow)
                switch result {
                case let .overFlow(packed, overFlow: _):
                    self.packedObjects = packed
                case let .packed(items):
                    self.packedObjects = items
                }
            }
            .store(in: &cancellables)
    }
    
    func clearMetrics() {
        time = 0
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

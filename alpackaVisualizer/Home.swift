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
    var body: some View {
        VStack {
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
            Text("Insert")
            HStack {
                TextField("Amount to insert", text: $insertCount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
                Button(action: {
                    self.add()
                    self.pack()
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
                }) {
                    Rectangle()
                        .cornerRadius(10)
                        .overlay(Image(systemName: "trash").foregroundColor(.white))
                }
                .foregroundColor(.red)
                .padding()
            }
            .frame(height: 80)
            PackingRect(objects: $objects)
                .border(Color.black)
                .frame(width: 400, height: 400)
                .background(Color.gray)
                .padding()
        }
    }
    
    func add() {
        for _ in 1...Int(insertCount)! {
            let objectHeight = heightRandom ? CGFloat(Int.random(in: Int(minHeight)!...Int(height)!)) : CGFloat(Double(height)!)
            let objectWidth = widthRandom ? CGFloat(Int.random(in: Int(minWidth)!...Int(width)!)) : CGFloat(Double(width)!)
            objects.append(PackableObject(origin: CGPoint.zero, width: objectWidth, height: objectHeight))
        }
    }
    
    func pack() {
        Alpacka.Packer().pack(objects, origin: \.origin, in: CGSize(width: 400, height: 400)) { result in
            switch result {
            case let .overFlow(packed, overFlow: _):
                self.objects = packed
            case let .success(packed):
                self.objects = packed
            }
        }
    }
}

struct SizeControl: View {
    @Binding var size: String
    @Binding var minimum: String
    @Binding var random: Bool
    let title: String
    var body: some View {
        HStack {
            if random {
                TextField("Min", text: $minimum)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding([.leading, .trailing], 15)
                Text("to")
                    .font(.system(size: 15))
            }
            TextField(random ? "Max" : title, text: $size)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding([.leading, .trailing], 15)
            VStack {
                Toggle(isOn: $random) { EmptyView() }
            }
            .padding([.leading, .trailing], 15)
        }
    }
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

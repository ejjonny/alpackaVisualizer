//
//  SizeControl.swift
//  alpackaVisualizer
//
//  Created by Ethan John on 1/3/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import SwiftUI

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
#if os(iOS)
                    .keyboardType(.numberPad)
#endif
                    .padding([.leading, .trailing], 15)
                Text("to")
                    .font(.system(size: 15))
            }
            TextField(random ? "Max" : title, text: $size)
                .textFieldStyle(RoundedBorderTextFieldStyle())
#if os(iOS)
                .keyboardType(.numberPad)
#endif
                .padding([.leading, .trailing], 15)
            VStack {
                Toggle(isOn: $random) { EmptyView() }
            }
            .padding([.leading, .trailing], 15)
        }
    }
}

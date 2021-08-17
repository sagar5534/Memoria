//
//  Test.swift
//  Memoria
//
//  Created by Om Patel on 2021-08-17.
//

import SwiftUI

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button("Dismiss Modal") {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct TestView: View {
    @State private var isPresented = false

    var body: some View {
        Button("Present!") {
            isPresented.toggle()
        }
        .sheet(isPresented: $isPresented, content: FullScreenModalView.init)
    }
}

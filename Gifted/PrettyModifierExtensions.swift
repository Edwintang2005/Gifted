//
//  PrettyModifierExtensions.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI

extension TextField {
    func pretty() -> some View {
        self.padding()
            .border(Color.gray, width: 1)
            .cornerRadius(3)
    }
}

extension SecureField {
    func pretty() -> some View {
        self.padding()
            .border(Color.gray, width: 1)
            .cornerRadius(3)
    }
}

extension Button {
    func pretty() -> some View {
        self.padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(3)
    }
}

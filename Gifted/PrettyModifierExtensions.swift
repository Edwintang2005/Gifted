//
//  PrettyModifierExtensions.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI

extension Text{
    func pretty() -> some View{
        self.font(.title2)
            .multilineTextAlignment(.center)
    }
}

extension TextField {
    func pretty() -> some View {
        self.padding()
            .border(Color.gray)
            .cornerRadius(3)
    }
}

extension SecureField {
    func pretty() -> some View {
        self.padding()
            .border(Color.gray)
            .cornerRadius(3)
    }
}

extension Button {
    func pretty() -> some View {
        self.font(.title3)
            .padding(.all)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(50)
            .shadow(color: Color.black.opacity(0.2), radius: 30, x: 2, y: 2)
            .padding(.vertical)
    }
}

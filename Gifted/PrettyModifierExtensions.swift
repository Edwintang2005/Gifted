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
    func small() -> some View{
        self.font(.caption)
            .foregroundColor(Color.gray)
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
            .padding(.all)
    }
    func floaty() -> some View {
        self.font(.system(size:60))
            .shadow(color: Color.gray.opacity(0.5), radius: 0.2, x: 2, y: 2)
            .padding(.all)
    }
    func google() -> some View{
        self.font(.body.weight(.medium))
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .foregroundColor(Color(.systemBackground))
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(.clear.opacity(0.25), lineWidth: 0)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(.displayP3, red: 219/255, green: 68/255, blue: 55/255)))
            }
    }
    func facebook() -> some View{
        self.font(.body.weight(.medium))
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .clipped()
            .foregroundColor(Color(.systemBackground))
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.displayP3, red: 23/255, green: 120/255, blue: 242/255))
            }
    }
}

extension TextEditor{
    func pretty() -> some View{
        self.padding()
            .border(Color.gray)
            .cornerRadius(3)
    }
}

extension Link{
    func pretty() -> some View{
        self.font(.title3)
            .padding(.all)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(50)
            .shadow(color: Color.black.opacity(0.2), radius: 30, x: 2, y: 2)
            .padding(.all)
    }
}

// Code for Labelled Divider
struct LabelledDivider: View {

    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 20, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack {
            line
            Text(label).foregroundColor(color)
            line
        }
    }

    var line: some View {
        VStack { Divider().background(color) }.padding(horizontalPadding)
    }
}

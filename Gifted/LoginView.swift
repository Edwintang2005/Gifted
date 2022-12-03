//
//  LoginView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            // can be app icon - Edwin
            Image(uiImage: UIImage(named: "WishlistLoading.jpg") ?? .init())
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: 356, maxHeight: 480, alignment: .top)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 11) {
                    VStack(alignment: .leading, spacing: 1) {
                        
                    }
                }
                .padding(.all)
                .padding(.top, 42)
                }
                .overlay(alignment: .bottom) {
                    HStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .clipped()
                .padding()
                .background {
                    Group {
                    
                }
                }
                .padding()
                }
                .mask {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                }
                .padding()
                .padding(.top, 40)
                .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.15), radius: 18, x: 0, y: 14)
            
            
            // vertical stack created for easier button placement
            VStack(spacing: 10) {
                // Button for email signin
                Button{
                    print("Email Button clicked") // Dud function, replace later
                } label: {
                    Image(systemName: "envelope.fill")
                        .imageScale(.medium)
                    Text("Continue with Email")
                }
                .font(.body.weight(.medium))
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .clipped()
                .foregroundColor(Color(.displayP3, red: 244/255, green: 188/255, blue: 73/255))
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.clear.opacity(0.25), lineWidth: 0)
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.yellow.opacity(0.1)))
                }
                // Button for Gmail Signin
                Button{ action:do {
                    print("Gmail Button clicked") // Dud function, replace later
                }
                } label: {
                    Image(systemName: "envelope.fill")
                        .imageScale(.medium)
                    Text("Continue with Gmail")
                }
                .font(.body.weight(.medium))
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(.systemBackground))
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.clear.opacity(0.25), lineWidth: 0)
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(.displayP3, red: 219/255, green: 68/255, blue: 55/255)))
                }
                // Function for Apple signin
                Button{
                    print("Facebook Button Pressed") // Dud function, replace later
                } label: {
                    Image(systemName: "f.cursive")
                        .imageScale(.medium)
                    Text("Continue with Facebook")
                }
                .font(.body.weight(.medium))
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .clipped()
                .foregroundColor(Color(.systemBackground))
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(.displayP3, red: 23/255, green: 120/255, blue: 242/255))
                }
                Text("Sign Up")
                    .padding(.top)
                    .foregroundColor(Color(.tertiaryLabel))
                    .font(.subheadline)
            }
            .padding(.horizontal)
            Spacer()
        }
        .frame(width: 390, height: 844)
        .clipped()
        .background(Color(.systemBackground))
        .mask { RoundedRectangle(cornerRadius: 43, style: .continuous) }
    }
}


// Ignore below, simulator code
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

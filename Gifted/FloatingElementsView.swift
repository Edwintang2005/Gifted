//
//  FloatingElementsView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI

//Floating Button used in Friends
struct Floating_Button_Friends: View{

    var body: some View{
        Button{
            print("Floating Button Test")
        } label: {
            Image(systemName: "plus.circle.fill")
        }
        .font(.system(size:80))
        .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
        Spacer(minLength: 1200)
        }
    }


//Floating Button used in Friends
struct Floating_Button_List: View{

    var body: some View{
        Button{
            print("Floating Button Test")
        } label: {
            Image(systemName: "plus.circle.fill")
        }
        .font(.system(size:80))
        .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
        Spacer(minLength: 1200)
        }
    

    }

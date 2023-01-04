//
//  AllStructureModifierExtensions.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI
import Foundation
import PhotosUI



// Visual Elements Extensions
extension Text{
    func pretty() -> some View{
        self.font(.title2)
            .multilineTextAlignment(.center)
            .padding(.all)
    }
    func listtext() -> some View{
        self.font(.subheadline)
            .multilineTextAlignment(.leading)
    }
    
    func small() -> some View{
        self.font(.caption)
            .foregroundColor(Color.gray)
            .multilineTextAlignment(.center)
    }
    func medium() -> some View{
        self.font(.footnote)
            .foregroundColor(Color.gray)
            .multilineTextAlignment(.center)
    }
    func large() -> some View{
        self.font(.callout)
            .multilineTextAlignment(.center)
    }
    func homepagename() -> some View{
        self.font(.headline)
            .foregroundColor(.secondary)
    }
    func verif() -> some View{
        self.font(.headline)
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
        self.font(.headline)
            .padding(.all)
            .frame(maxWidth: .infinity)
            .foregroundColor(Color(.systemBackground))
            .background(Color.primary)
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
                .fill(Color(.displayP3, red: 66/255, green: 103/255, blue: 178/255))
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

extension Image{
    func floaty() -> some View{
        self.font(.system(size:60))
            .shadow(color: Color.gray.opacity(0.5), radius: 0.2, x: 2, y: 2)
            .padding(.all)
    }
    func Icon() -> some View{
        self.renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 60, height: 50)
            .mask { RoundedRectangle(cornerRadius: 4, style: .continuous) }
    }
}

// Attempted extension for overlay code of who has reserved, not working
//extension VStack{
//    func ImageOverlay(selfQuery: Bool) -> some View{
//        if selfQuery == true {
//            self.padding(.all)
//        } else {
//            self.padding(.all)
//            // Overlay of image to represent people who have reserved the item, No actual logic or data structure attatched to this yet
//                .overlay{
//                    HStack {
//                        Image(systemName: "a.circle.fill")
//                            .imageScale(.large)
//                    }
//                    .font(.title3)
//                    .padding(.horizontal)
//                }
//        }
//    }
//}


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

//Code for Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}



// AWS Data structure Extensions
extension ListItem: Identifiable {}

extension ListItem: Equatable{
    public static func ==(lhs: ListItem, rhs: ListItem) -> Bool {
        lhs.id == rhs.id && lhs.Name == rhs.Name
    }
}

extension ListItem: Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id + Name)
    }
}

extension Group: Identifiable {}

extension Group: Equatable {
    public static func == (lhs: Group, rhs: Group)
        -> Bool {
            lhs.id == rhs.id && lhs.ShortID == rhs.ShortID
    }
}

extension Group: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id + ShortID)
    }
}

extension UserProfile: Identifiable {}

extension UserProfile: Equatable{
    public static func ==(lhs: UserProfile, rhs: UserProfile) -> Bool {
        lhs.id == rhs.id && lhs.Username == rhs.Username
    }
}

extension UserProfile: Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id + Username)
    }
}

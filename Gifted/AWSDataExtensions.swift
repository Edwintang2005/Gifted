//
//  AWSDataExtensions.swift
//  Gifted
//
//  Created by Edwin Tang on 5/12/2022.
//

import Foundation

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

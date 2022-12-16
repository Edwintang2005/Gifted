//
//  MenuViewController.swift
//  Gifted
//
//  Created by Edwin Tang on 16/12/2022.
//

import Foundation

enum MenuDisplay {
    case mainWindow
    case list
    case friends
    case groups
}

final class MenuViewController: ObservableObject {
    
    @Published var menuDisplay: MenuDisplay = .mainWindow
    
    
    func showMain() {
        menuDisplay = .mainWindow
    }
    
    func showList() {
        menuDisplay = .list
    }
    
    func showFriends() {
        menuDisplay = .friends
    }
    
    func showGroups() {
        menuDisplay = .groups
    }
}

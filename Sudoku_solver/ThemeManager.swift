//
//  ThemeManager.swift
//  Sudoku_solver
//
//  Created by Menno Konijn on 23/02/2024.
//

import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    // Manages the selected theme from the homepage
    @Published var isDarkMode: Bool = false

    func toggleTheme() {
        isDarkMode.toggle()
    }
}

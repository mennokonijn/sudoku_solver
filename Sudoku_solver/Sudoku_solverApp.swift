//
//  Sudoku_solverApp.swift
//  Sudoku_solver
//
//  Created by Menno Konijn on 31/01/2024.
//

import SwiftUI

@main
struct Sudoku_solverApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            HomePage()
                .environmentObject(themeManager)
        }
    }
}

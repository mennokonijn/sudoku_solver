//
//  BackgroundView.swift
//  Sudoku_solver
//
//  Created by Menno Konijn on 23/02/2024.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        // Use a condition to determine the background color
        Color.black.edgesIgnoringSafeArea(.all)
    }
}

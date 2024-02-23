//
//  ContentView.swift
//  Sudoku_solver
//
//  Created by Menno Konijn on 31/01/2024.
//

import SwiftUI
import Combine

struct SudokuView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    // Have a prefilled sudoku for the demo
    private let filledInPuzzle: [[Int?]] = [
        [5, 3, nil, nil, 7, nil, nil, nil, nil],
        [6, nil, nil, 1, 9, 5, nil, nil, nil],
        [nil, 9, 8, nil, nil, nil, nil, 6, nil],
        [8, nil, nil, nil, 6, nil, nil, nil, 3],
        [4, nil, nil, 8, nil, 3, nil, nil, 1],
        [7, nil, nil, nil, 2, nil, nil, nil, 6],
        [nil, 6, nil, nil, nil, nil, 2, 8, nil],
        [nil, nil, nil, 4, 1, 9, nil, nil, 5],
        [nil, nil, nil, nil, 8, nil, nil, 7, 9]
    ]
    
    // All states in the application
    @State private var puzzle: [[Int?]] = Array(repeating: Array(repeating: nil, count: 9), count: 9)
    @State private var solution: [[Int]]?
    @State private var error: String?
    @State private var inputs: [[String]] = Array(repeating: Array(repeating: "", count: 9), count: 9)
    
    // Populate inputs from puzzle
    private func populateInputsFromPuzzle() {
        puzzle = filledInPuzzle
        for row in 0..<puzzle.count {
            for col in 0..<puzzle[row].count {
                if let value = puzzle[row][col] {
                    inputs[row][col] = String(value)
                } else {
                    inputs[row][col] = ""
                }
            }
        }
    }

    var body: some View {
        ZStack {
            themeManager.isDarkMode ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                header
                if solution == nil {
                    puzzleInput
                    HStack {
                        solveButton
                    }
                }
                if let solution = solution {
                    solutionDisplay(for: solution)
                    HStack {
                        resetButton
                    }
                }
                Spacer()
            }
            .onAppear {
                populateInputsFromPuzzle()
            }
            .padding(.horizontal)
            .padding(.top, 32)
        }
    }

    private var header: some View {
        VStack {
            Text("Sudoku Solver")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(themeManager.isDarkMode ? Color.white : Color.black)
        }
    }

    private var puzzleInput: some View {
        VStack {
            Spacer()
            Text("Please fill in the sudoku that must be solved")
                .font(.body)
                .padding(.bottom, 16)
                .foregroundColor(themeManager.isDarkMode ? Color.white : Color.black)
            VStack(spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<9, id: \.self) { col in
                            TextField("", text: self.$inputs[row][col])
                                .onReceive(Just(inputs[row][col])) { newValue in
                                    
                                    // Check if the value is between 1 and 9
                                    let filtered = newValue.filter { char in
                                        if let digit = Int(String(char)) {
                                            return digit >= 1 && digit <= 9
                                        }
                                        return false
                                    }
                                    if filtered != newValue {
                                        self.inputs[row][col] = filtered
                                    }
                                    
                                    updatePuzzleState(row: row, col: col, with: filtered)
                                }
                                .frame(width: 40, height: 40)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .background(themeManager.isDarkMode ? Color(red: 51/255, green: 51/255, blue: 51/255) : Color(red: 255/255, green: 242/255, blue: 230/255))
                                .foregroundColor(themeManager.isDarkMode ? Color.white : Color.black)
                        }
                    }
                }
            }
            .overlay(
                GeometryReader { geo in
                    self.gridLines(geometry: geo)
                }
            )
            if let error = error {
                Text(error)
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.red)
            }
            Spacer()
            Spacer()
        }
    }
    

    private func solutionDisplay(for solution: [[Int]]) -> some View {
        VStack {
            Spacer()
            Text("This is the result")
                .font(.body)
                .padding(.bottom, 16)
            VStack(spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<9, id: \.self) { col in
                            Text("\(solution[row][col])")
                                .frame(width: 40, height: 40)
                                .multilineTextAlignment(.center)
                                .background(themeManager.isDarkMode ? Color(red: 51/255, green: 51/255, blue: 51/255) : Color(red: 255/255, green: 242/255, blue: 230/255))
                                .foregroundColor(themeManager.isDarkMode ? Color.white : Color.black)
                        }
                    }
                }
            }
            .overlay(
                GeometryReader { geo in
                    self.gridLines(geometry: geo)
                }
            )
            Spacer()
            Spacer()
        }
    }
    
    private func cellBackground(forRow row: Int, col: Int) -> some View {
            Color.clear
        }

    private func gridLines(geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let normalLineWidth: CGFloat = 1
            let thickLineWidth: CGFloat = 2
        
        return ZStack {
            // Draw thin lines for not 3x3 subgrid boundaries
            Path { path in
                for i in 1..<9 {
                    if i % 3 != 0 {
                        let y = height / 9 * CGFloat(i)
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                        
                        let x = width / 9 * CGFloat(i)
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))
                    }
                }
            }
            .stroke(themeManager.isDarkMode ? Color.white : Color.black, lineWidth: normalLineWidth)
            
            // Draw thicker lines for 3x3 subgrid boundaries
            Path { path in
                for i in 1..<9 {
                    if i % 3 == 0 {
                        let y = height / 9 * CGFloat(i)
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                        
                        let x = width / 9 * CGFloat(i)
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))
                    }
                }
            }
            .stroke(themeManager.isDarkMode ? Color.white : Color.black, lineWidth: thickLineWidth)
        }
        .overlay(
            Rectangle() // Draw the border around the entire grid
                .stroke(themeManager.isDarkMode ? Color.white : Color.black, lineWidth: thickLineWidth)
                .frame(width: width, height: height)
        )
    }

    private var solveButton: some View {
        let puzzleWithZeros: [[Int]] = self.getPuzzleWithZeros()

        // Button to solve the grid
        return Button("Solve") {
            let solved = SudokuSolver(puzzle: puzzleWithZeros).solve()
            
            switch solved {
                case .solved(let solvedPuzzle):
                    solution = solvedPuzzle
                case .failure(let error):
                    self.error = error
            }

        }
        .font(.title2)
        .frame(minWidth: 150)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        )
        .padding()
    }
    
    private var resetButton: some View {
        // Button to reset the grid
        Button("Reset") {
            solution = nil
            puzzle = Array(repeating: Array(repeating: nil, count: 9), count: 9)
            inputs =  Array(repeating: Array(repeating: "", count: 9), count: 9)
            error = nil
        }
        .font(.title2)
        .frame(minWidth: 150)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        )
        .padding()
    }

    private func updatePuzzleState(row: Int, col: Int, with input: String) {
        // Updated a value in the sudoku if between 1 and 9
        if let value = Int(input), (1...9).contains(value) {
            self.puzzle[row][col] = value
        } else {
            self.puzzle[row][col] = nil
        }
    }
    
    private func getPuzzleWithZeros() -> [[Int]] {
        // replaces all empty values with zero
        return puzzle.map { row in
            row.map { $0 ?? 0 }
        }
    }
}


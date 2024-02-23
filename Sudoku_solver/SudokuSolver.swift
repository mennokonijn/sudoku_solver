//
//  sudokuSoolver.swift
//  Sudoku_solver
//
//  Created by Menno Konijn on 31/01/2024.
//

import Foundation

enum SolveResult {
    case solved([[Int]])
    case failure(String)
}

enum ValidateResult {
    case validated
    case failure(String)
}

class SudokuSolver {
    var puzzle: [[Int]]
    var rows: [[Bool]]
    var cols: [[Bool]]
    var boxes: [[Bool]]
    
    init(puzzle: [[Int]]) {
        self.puzzle = puzzle
        self.rows = Array(repeating: Array(repeating: false, count: 9), count: 9)
        self.cols = Array(repeating: Array(repeating: false, count: 9), count: 9)
        self.boxes = Array(repeating: Array(repeating: false, count: 9), count: 9)
        
        // Initial fill for rows, cols, and boxes
        for i in 0..<9 {
            for j in 0..<9 {
                if puzzle[i][j] != 0 {
                    let num = puzzle[i][j] - 1 // Adjusting for 0-indexed
                    rows[i][num] = true
                    cols[j][num] = true
                    boxes[(i / 3) * 3 + j / 3][num] = true
                }
            }
        }
    }
    
    func solve() -> SolveResult {
        var copy = puzzle
        
        let validationResult = validateInitialPuzzle(puzzle: copy)
        
        switch validationResult {
            case .validated:
                if solveSudoku(&copy, 0, 0) {
                    return .solved(copy)
                } else {
                    return .failure("This is an unsolvable sudoku")
                }
            case .failure(let error):
                return .failure(error)
        }
        
    }
    
    private func solveSudoku(_ board: inout [[Int]], _ row: Int, _ col: Int) -> Bool {
        var cRow = row
        var cCol = col
        if cCol == 9 {
            cRow += 1
            cCol = 0
        }
        if cRow == 9 {
            return true
        }
        
        if board[cRow][cCol] != 0 {
            return solveSudoku(&board, cRow, cCol + 1)
        }
        
        // Check for all numbers
        for num in 1...9 {
            if isSafe(cRow, cCol, num - 1) { // Adjusting for 0-indexed
                board[cRow][cCol] = num
                rows[cRow][num - 1] = true
                cols[cCol][num - 1] = true
                boxes[(cRow / 3) * 3 + cCol / 3][num - 1] = true
                
                if solveSudoku(&board, cRow, cCol + 1) {
                    return true
                }
                
                board[cRow][cCol] = 0
                rows[cRow][num - 1] = false
                cols[cCol][num - 1] = false
                boxes[(cRow / 3) * 3 + cCol / 3][num - 1] = false
            }
        }
        return false
    }
    
    // Check if the number can be placed in the position
    private func isSafe(_ row: Int, _ col: Int, _ num: Int) -> Bool {
           !rows[row][num] && !cols[col][num] && !boxes[(row / 3) * 3 + col / 3][num]
       }
    
    
    func validateInitialPuzzle(puzzle: [[Int?]]) -> ValidateResult {
        // Check rows for duplicates
        for row in puzzle {
            if !isValidGroup(group: row) {
                return .failure("Duplicate value in one of the rows")
            }
        }
        
        // Check columns for duplicates
        for i in 0..<9 {
            var column = [Int?]()
            for j in 0..<9 {
                column.append(puzzle[j][i])
            }
            if !isValidGroup(group: column) {
                return .failure("Duplicate value in one of the columns")
            }
        }
        
        // Check 3x3 sub-grids for duplicates
        for i in stride(from: 0, to: 9, by: 3) {
            for j in stride(from: 0, to: 9, by: 3) {
                var grid = [Int?]()
                for k in 0..<3 {
                    for l in 0..<3 {
                        grid.append(puzzle[i+k][j+l])
                    }
                }
                if !isValidGroup(group: grid) {
                    return .failure("Duplicate value in one of the 3x3 grids")
                }
            }
        }
        
        return .validated
    }

    func isValidGroup(group: [Int?]) -> Bool {
        var numbers = Set<Int>()
        for number in group {
            if let number = number {
                if numbers.contains(number) {
                    // Found a duplicate number
                    return false
                }
                if (number != 0) {
                    numbers.insert(number)
                }
            }
        }
        // No duplicates found
        return true
    }
}

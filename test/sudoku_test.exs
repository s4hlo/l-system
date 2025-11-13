defmodule SudokuTest do
  use ExUnit.Case

  # 4x4 Sudoku Tests (order 4, box size 2x2)
  describe "4x4 Sudoku" do
    test "valid complete 4x4 sudoku" do
      grid = [
        [1, 2, 3, 4],
        [3, 4, 1, 2],
        [2, 1, 4, 3],
        [4, 3, 2, 1]
      ]
      
      # Assuming a function like valid_sudoku?/1 or is_valid/1
      # TODO: Uncomment and update with your function name
      # assert YourModule.valid_sudoku?({grid, 4}) == true
    end

    test "valid incomplete 4x4 sudoku with zeros" do
      grid = [
        [1, 0, 3, 4],
        [3, 4, 0, 2],
        [0, 1, 4, 3],
        [4, 3, 2, 0]
      ]
      
      # TODO: Uncomment and update with your function name
      # assert YourModule.valid_sudoku?({grid, 4}) == true
    end

    test "invalid 4x4 sudoku - duplicate in row" do
      grid = [
        [1, 1, 3, 4],  # duplicate 1 in first row
        [3, 4, 1, 2],
        [2, 1, 4, 3],
        [4, 3, 2, 1]
      ]
      
      # assert Sudoku.valid_sudoku?({grid, 4}) == false
    end

    test "invalid 4x4 sudoku - duplicate in column" do
      grid = [
        [1, 2, 3, 4],
        [1, 4, 1, 2],  # duplicate 1 in first column
        [2, 1, 4, 3],
        [4, 3, 2, 1]
      ]
      
      # assert Sudoku.valid_sudoku?({grid, 4}) == false
    end

    test "invalid 4x4 sudoku - duplicate in 2x2 box" do
      grid = [
        [1, 1, 3, 4],  # duplicate 1 in top-left 2x2 box
        [3, 4, 1, 2],
        [2, 1, 4, 3],
        [4, 3, 2, 1]
      ]
      
      # assert Sudoku.valid_sudoku?({grid, 4}) == false
    end

    test "invalid 4x4 sudoku - value out of range" do
      grid = [
        [1, 2, 3, 5],  # 5 is out of range (should be 1-4)
        [3, 4, 1, 2],
        [2, 1, 4, 3],
        [4, 3, 2, 1]
      ]
      
      # assert Sudoku.valid_sudoku?({grid, 4}) == false
    end

    test "valid 4x4 sudoku - all zeros (empty grid)" do
      grid = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
      ]
      
      # TODO: Uncomment and update with your function name
      # assert YourModule.valid_sudoku?({grid, 4}) == true
    end
  end

  # 9x9 Sudoku Tests (order 9, box size 3x3)
  describe "9x9 Sudoku" do
    test "valid complete 9x9 sudoku" do
      grid = [
        [5, 3, 4, 6, 7, 8, 9, 1, 2],
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 9]
      ]
      
      # assert Sudoku.valid_sudoku?({grid, 9}) == true
    end

    test "valid incomplete 9x9 sudoku with zeros" do
      grid = [
        [5, 3, 0, 0, 7, 0, 0, 0, 0],
        [6, 0, 0, 1, 9, 5, 0, 0, 0],
        [0, 9, 8, 0, 0, 0, 0, 6, 0],
        [8, 0, 0, 0, 6, 0, 0, 0, 3],
        [4, 0, 0, 8, 0, 3, 0, 0, 1],
        [7, 0, 0, 0, 2, 0, 0, 0, 6],
        [0, 6, 0, 0, 0, 0, 2, 8, 0],
        [0, 0, 0, 4, 1, 9, 0, 0, 5],
        [0, 0, 0, 0, 8, 0, 0, 7, 9]
      ]
      
      # assert Sudoku.valid_sudoku?({grid, 9}) == true
    end

    test "invalid 9x9 sudoku - duplicate in row" do
      grid = [
        [5, 3, 4, 6, 7, 8, 9, 1, 2],
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 1]  # duplicate 1 in last row
      ]
      
      # TODO: Uncomment and update with your function name
      # assert YourModule.valid_sudoku?({grid, 9}) == false
    end

    test "invalid 9x9 sudoku - duplicate in column" do
      grid = [
        [5, 3, 4, 6, 7, 8, 9, 1, 2],
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 9],
        [5, 3, 4, 6, 7, 8, 9, 1, 2]  # duplicate 5 in first column
      ]
      
      # Actually, let me fix this - can't have 10 rows
      grid = [
        [5, 3, 4, 6, 7, 8, 9, 1, 2],
        [5, 7, 2, 1, 9, 5, 3, 4, 8],  # duplicate 5 in first column
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 9]
      ]
      
      # TODO: Uncomment and update with your function name
      # assert YourModule.valid_sudoku?({grid, 9}) == false
    end

    test "invalid 9x9 sudoku - duplicate in 3x3 box" do
      grid = [
        [5, 3, 4, 6, 7, 8, 9, 1, 2],
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 5]  # duplicate 5 in bottom-right 3x3 box
      ]
      
      # TODO: Uncomment and update with your function name
      # assert YourModule.valid_sudoku?({grid, 9}) == false
    end

    test "invalid 9x9 sudoku - value out of range" do
      grid = [
        [5, 3, 4, 6, 7, 8, 9, 1, 2],
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 10]  # 10 is out of range (should be 1-9)
      ]
      
      # TODO: Uncomment and update with your function name
      # assert YourModule.valid_sudoku?({grid, 9}) == false
    end

    test "valid 9x9 sudoku - all zeros (empty grid)" do
      grid = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0]
      ]
      
      # assert Sudoku.valid_sudoku?({grid, 9}) == true
    end

    test "invalid 9x9 sudoku - duplicate zero in incomplete grid" do
      grid = [
        [5, 3, 0, 0, 7, 0, 0, 0, 0],
        [6, 0, 0, 1, 9, 5, 0, 0, 0],
        [0, 9, 8, 0, 0, 0, 0, 6, 0],
        [8, 0, 0, 0, 6, 0, 0, 0, 3],
        [4, 0, 0, 8, 0, 3, 0, 0, 1],
        [7, 0, 0, 0, 2, 0, 0, 0, 6],
        [0, 6, 0, 0, 0, 0, 2, 8, 0],
        [0, 0, 0, 4, 1, 9, 0, 0, 5],
        [0, 0, 0, 0, 8, 0, 0, 7, 9]
      ]
      
      # This should be valid - zeros don't count as duplicates
      # assert Sudoku.valid_sudoku?({grid, 9}) == true
    end
  end
end

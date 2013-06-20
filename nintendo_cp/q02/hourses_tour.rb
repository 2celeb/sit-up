require 'set'
require_relative './utility'

module HoursesTour
  class Solver
    def initialize(grid)
      @grid = grid
      @path = []
      @solutions = []
    end

    def can_move?(x, y, to_x, to_y)
      movable_positions(x, y).include?([to_x, to_y])
    end

    def movable_positions(x, y)
      positions = Set.new([[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]])
      1.upto(8) do |c|
        positions << ([x + c, y + c])
        positions << ([x - c, y + c])
        positions << ([x + c, y - c])
        positions << ([x - c, y - c])
      end
      positions.find_all { |position| in_grid?(*position) }
    end

    def solve(x, y)
      solve_with_backtracking(x, y, @grid.cell(x, y).to_i)
      @solutions
    end

    def solve_with_backtracking(x, y, k)
      @path << [x, y]
      if k == 9
        @solutions << @path.clone if can_move?(x, y, @path[0][0], @path[0][1])
      else
        movable_positions(x, y).each{|nx, ny|
          if @grid.cell(nx, ny).to_i == k+1
            solve_with_backtracking(nx, ny, k+1)
          end
        }
      end
      @path.pop
    end

    private

    def in_grid?(x, y)
      x.between?(1, 9) && y.between?(1, 9)
    end
  end
end

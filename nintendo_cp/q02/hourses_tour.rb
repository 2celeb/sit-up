module HoursesTour
  class Solver
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
  end
end

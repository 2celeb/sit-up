# -*- coding: utf-8 -*-
require 'set'
require './utility'

module NumberPlace
  class Solver
    ALL_NUMBERS = Set.new(1..9)

    def initialize(grid)
      @grid = grid
    end

    def list_candidates_column(x)
      ALL_NUMBERS - (1..9).map{|i| @grid.cell(x, i).to_i}
    end

    def list_candidates_column(x)
      ALL_NUMBERS - (1..9).map{|i| @grid.cell(x, i).to_i}
    end

    def list_candidates_row(y)
      ALL_NUMBERS - (1..9).map { |i| @grid.cell(i, y).to_i }
    end

    def list_candidates_block(x, y)
      block_x = ((x - 1) / 3) * 3 + 1
      block_y = ((y - 1) / 3) * 3 + 1
      ALL_NUMBERS - (block_x  .. block_x + 2).map { |col| (block_y .. block_y + 2).map { |row| @grid.cell(col, row).to_i } }.flatten
    end

    def list_candidates(x, y)
      list_candidates_column(x) & list_candidates_row(y) & list_candidates_block(x, y)
    end

    def solve_simple
      (1 .. 9).each do |x|
        (1 .. 9).each do |y|
          next unless @grid.cell(x, y).to_i == 0
          candidates = list_candidates(x, y)
          if candidates.count == 1
            @grid.set_cell(x, y, candidates.first)
          end
        end
      end
    end

    def solve
      solve_with_backtracking
      @grid
    end

    def solve_with_backtracking
      solve_simple()                  # まず、答が確定するところは解き進めます

      next_zero = @grid.index("0")
      return true if next_zero.nil?   # もう0が残っていない＝解答発見

      # 0 のマスに対して、候補を一つずつ仮置きしてみます
      x, y = @grid.index2pos(next_zero)
      list_candidates(x, y).each{|k|
        saved_grid = @grid.clone      # 盤面を保存しておく
        @grid.set_cell(x, y, k)       # 数字を仮置きする

        if solve_with_backtracking()
          return true                 # 答が見つかったら盤面を @grid に残したままで終了
        end

        @grid = saved_grid            # 汚れた盤面を保存した状態に戻す
      }

      return false                    # 答が見つからなかった
    end
  end
end

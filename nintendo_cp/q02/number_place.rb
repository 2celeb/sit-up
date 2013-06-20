# -*- coding: utf-8 -*-
module NumberPlace
  class Solver
    ALL_NUMBERS = Set.new(1..9)

    def list_candidates_column(x)
      ALL_NUMBERS - (1..9).map{|i| @grid.cell(x, i).to_i}
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

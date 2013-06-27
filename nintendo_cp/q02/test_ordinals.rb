require 'test/unit'
require './second_page.rb'
require './ordinals.rb'

class TestCase_Ordinals < Test::Unit::TestCase

  def test_twentytwo
    assert($ordinals[21] < $grid.size)
    assert($ordinals[22] >= $grid.size)
  end

  def test_no_divisors
    $ordinals[0..21].each{|v|
      assert_equal(true,
                   (2...v).all?{|divisor|
                     v % divisor != 0
                   })
    }
  end

end

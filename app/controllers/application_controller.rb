class ApplicationController < ActionController::API
  def cwmonth(cweek)
    case cweek
    when 1..4
      return 1
    when 5..8
      return 2
    when 9..13
      return 3
    when 14..17
      return 4
    when 18..21
      return 5
    when 22..26
      return 6
    when 27..30
      return 7
    when 31..34
      return 8
    when 35..39
      return 9
    when 40..43
      return 10
    when 44..47
      return 11
    when 48..52
      return 12
    end
  end
end

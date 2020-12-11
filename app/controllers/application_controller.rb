# frozen_string_literal: true

class ApplicationController < ActionController::API
  def cwmonth(cweek)
    case cweek
    when 1..4
      1
    when 5..8
      2
    when 9..13
      3
    when 14..17
      4
    when 18..21
      5
    when 22..26
      6
    when 27..30
      7
    when 31..34
      8
    when 35..39
      9
    when 40..43
      10
    when 44..47
      11
    when 48..52
      12
    end
  end

  def cweeks(cwmonth)
    case cwmonth
    when 1
      [1, 2, 3, 4]
    when 2
      [5, 6, 7, 8]
    when 3
      [9, 10, 11, 12, 13]
    when 4
      [14, 15, 16, 17]
    when 5
      [18, 19, 20, 21]
    when 6
      [22, 23, 24, 25, 26]
    when 7
      [27, 28, 29, 30]
    when 8
      [31, 32, 33, 34]
    when 9
      [35, 36, 37, 38, 39]
    when 10
      [40, 41, 42, 43]
    when 11
      [44, 45, 46, 47]
    when 12
      [48, 49, 50, 51, 52, 53]
    end
  end

  def weeksInRange(start, _end)
    startWeek = start.cweek
    startYear = start.cwyear
    endWeek = _end.cweek

    ret = [{ week: startWeek, month: cwmonth(startWeek), year: startYear }]
    currentWeek = startWeek
    currentYear = startYear
    while currentWeek != endWeek
      if currentWeek == 53
        currentWeek = 1
        currentYear += 1
      else
        currentWeek += 1
      end

      ret.append({ week: currentWeek, month: cwmonth(currentWeek), year: currentYear })
    end

    ret
  end
end

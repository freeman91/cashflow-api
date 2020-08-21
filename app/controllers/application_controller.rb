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

  def cweeks(cwmonth)
    case cwmonth
    when 1
      return [1, 2, 3, 4]
    when 2
      return [5, 6, 7, 8]
    when 3
      return [9, 10, 11, 12, 13]
    when 4
      return [14, 15, 16, 17]
    when 5
      return [18, 19, 20, 21]
    when 6
      return [22, 23, 24, 25, 26]
    when 7
      return [27, 28, 29, 30]
    when 8
      return [31, 32, 33, 34]
    when 9
      return [35, 36, 37, 38, 39]
    when 10
      return [40, 41, 42, 43]
    when 11
      return [44, 45, 46, 47]
    when 12
      return [48, 49, 50, 51, 52, 53]
    end
  end

  def weeksInRange(start, _end)
    startWeek = start.cweek()
    startYear = start.cwyear()
    endWeek = _end.cweek()

    ret = [{ :week => startWeek, :month => cwmonth(startWeek), :year => startYear }]
    currentWeek = startWeek
    currentYear = startYear
    while currentWeek != endWeek
      if currentWeek == 53
        currentWeek = 1
        currentYear += 1
      else
        currentWeek += 1
      end

      ret.append({ :week => currentWeek, :month => cwmonth(currentWeek), :year => currentYear })
    end

    return ret
  end
end

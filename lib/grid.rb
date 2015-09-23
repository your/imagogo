# github.com/your/ruby-grid

class Grid
  attr_accessor :rows, :cols, :grid

  def initialize(*args)
    case args.size
    when 2
      raise ArgumentError, 'Argument type(s) is not Integer' unless args.each { |a| a.is_a? Integer }
      @rows = args.first.to_i
      @cols = args[1].to_i
      @grid = init_matrix(@rows, @cols, 0)
    when 3
      @rows = args.first.to_i
      @cols = args[1].to_i
      val = args[2].to_a
      @grid = matrix_wrapper(val, 1) 
    else
      raise ArgumentError, 'Argument number (#{args.size}) is wrong'
    end
  end

  def init_matrix(m_rows, m_cols, val)
    matrix = Array.new(m_rows) { Array.new(m_cols) }
    matrix[0..m_rows-1].each { |row| fill_array(row, val) }
  end

  def matrix_wrapper(from_array, times)
    wrapper = []
    array = Array.new(1) { Array.new(from_array) }
    times.times { wrapper.concat(array) }
    wrapper
  end

#  def get_matrix_cols(matrix)
#    matrix.map { |el| el.size }.push(get_matrix_rows(matrix)).max
#  end

#  def get_matrix_rows(matrix)
#    matrix.size
#  end

 # def get_matrix_max(matrix)
 #   get_matrix_cols(matrix).push(get_matrix_rows(matrix)).max
 # end

  def set_value(row, col, val)
      raise ArgumentError, 'Argument type(s) is not Integer' unless (row.is_a? Integer) || (row.is_a? Integer) || (val.is_a? Integer)
      raise ArgumentError, 'Argument(s) (: 1, 2) cannot be negative Integer(s)' unless row >= 0 || col >= 0
      @grid[row][col] = val
  end

  def get_value(row, col)
    raise ArgumentError, 'Argument type(s) is not Integer' unless (row.is_a? Integer) || (row.is_a? Integer)
    raise ArgumentError, 'Argument(s) (: 1, 2, 3) cannot be negative Integer(s)' unless row >= 0 || col >= 0
    @grid[row][col]
  end

  def fill_array(array, val)
    array.map! { |point| point = val }
  end


  #################################################
  # GRID MANIPULATION
  #################################################

  ###### Grid rows expansion

  #
  #
  # @overload add_row(n_times, from_row)
  #   @param [Integer] n_times How many rows to add.
  #   @param [Integer] from_row Index to start expansion from.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times row(s) *after* from_row and filled with 0s.
  #
  # @overload add_row(n_times, from_row, init_val)
  #   @param [Integer] n_times How many rows to add.
  #   @param [Integer] from_row Index to start expansion from.
  #   @param [Integer] init_val Init value (Integer).
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times row(s) *after* from_row and filled with init_val.
  #
  # @overload add_row(n_times, from_row, src_array)
  #   @param [Integer] n_times How many rows to add.
  #   @param [Integer] from_row Index to start expansion from.
  #   @param [Array<Integer>] src_array Injecting array of Integers.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times src_array(s) *after* from_row.
  #
  # @overload add_row(n_times, from_row, init_val, direction)
  #   @param [Integer] n_times How many rows to add.
  #   @param [Integer] from_row Index to start expansion from.
  #   @param [Integer] init_val Init value (Integer).
  #   @param [Integer] direction 0: right, -1: left.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times row(s) from_row, filled with init_val,
  #   after or before the from_row index, according to the value of direction (0 for after, -1 for before).
  #
  # @overload add_row(n_times, from_row, src_array, direction)
  #   @param [Integer] n_times How many rows to add.
  #   @param [Integer] from_row Index to start expansion from.
  #   @param [Integer] src_array Injecting array of Integers.
  #   @param [Integer] direction 0: right, -1: left.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times src_array(s) from_row,
  #   after or before the from_row index, according to the value of direction (0 for after, -1 for before).
  #
  #
  # @note: WARN: When an out-of-range upper index is given, the default behaviour will be to 
  #  set the index to the grid upper-one, and proceed from there as expected.
  #  *NO exceptions will raise for this.*
  #
  #
  # @raise [ArgumentError] If something is wrong with them.
  #
  def add_row(*args)
    case args.size
    when 2..4
      raise ArgumentError, 'Argument type(s) is not Integer' unless args.each { |a| a.is_a? Integer }
      raise ArgumentError, 'Argument(s) (: 1, 2, 3) cannot be negative Integer(s)' unless args.each_with_index { |a,i| a.class != Array && ( a >= 0 && i < 3 ) }
      raise ArgumentError, 'Argument (: direction) shall be in range [-1,0]' unless  args.size < 4 || (args.size == 4 && args[3].to_i.between?(-1,0))

      cnt = args.first.to_i
      pos = args[1].to_i
      val = args.size == 2 ? 0 : args[2].class == Array ? args[2].to_a : args[2].to_i
      dir = args.size < 4 ? 0 : args[3].to_i

      pos = pos < @rows-1 ? pos : @rows-1 # ensure upper limit if out-of-range
      
      injecting_array = val.class == Array ? matrix_wrapper(val, cnt) : init_matrix(cnt, @cols, val)

      index = dir == 0 ? pos+1 : pos

      injecting_array.each { |el| @grid.insert(index, el); index += 1; }

      @rows += cnt
      @grid
    else
      raise ArgumentError, 'Argument number (#{args.size}) is wrong'
    end
  end

  ###### Grid rows collapse

  #
  #
  # @overload del_row(n_times, from_row)
  #   @return [Array<Integer>, Array[Integer]] Grid with removed n_times row(s) from_row (included) on (forward).
  #
  # @overload del_row(n_times, from_row, direction)
  #   @return [Array<Integer>, Array[Integer]] Grid with removed n_times row(s) from_row (included),
  #   forward if position is set to 0, backward if set to -1.
  #
  #
  # @note: WARN: When an out-of-range upper index is given, the default behaviour will be to 
  #  simply return the original grid without any modification.
  # @note: WARN: By default this function will try to process as many n_times possible,
  #  that is, if n_times exceeds the room available, it will will set n_times to the max room.
  #  If there is no room, it will return the grid untouched.
  #
  #
  # @param [Integer] n_times How many rows to remove.
  # @param [Integer] from_col Index to start collapsing from.
  # @param [Integer] direction (optional) 0: right, -1: left.
  # @raise [ArgumentError] if something is wrong with them.
  #
  def del_row(*args)
    case args.size
    when 2..3
      count = args.first.to_i
      position = args[1].to_i
      side = args.size == 2 ? 0 : args[2].to_i

      # enough room there?
      room = @rows-position
  
      if side == 0
        count = room > 0 ? (count > room ? room : count) : 0
      elsif side == -1
        count = room < 0 ? 0 : count > room ? room : count
      end 
      #p count
      disp = 0
      count.times {
        @grid.delete_at(position-disp)
        disp += 1 if side == -1 && position-disp >= 0
      }
      @rows -= count
      @grid
    else
      raise ArgumentError, 'Argument type(s) is not Integer' unless args.each { |a| a.is_a? Integer }
    end
  end

  ###### Grid columns expansion

  #
  #
  # @overload add_col(n_times, from_col)
  #   @param [Integer] n_times How many cols to add.
  #   @param [Integer] from_col Index to start expansion from.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times col(s) *after* from_col and filled with 0s.
  #
  # @overload add_col(n_times, from_col, init_val)
  #   @param [Integer] n_times How many cols to add.
  #   @param [Integer] from_col Index to start expansion from.
  #   @param [Integer] init_val Init value (Integer).
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times col(s) *after* from_col and filled with init_val.
  #
  # @overload add_col(n_times, from_col, src_array)
  #   @param [Integer] n_times How many cols to add.
  #   @param [Integer] from_col Index to start expansion from.
  #   @param [Array<Integer>] src_array Injecting array of Integers.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times src_array(s) *after* from_col.
  #
  # @overload add_col(n_times, from_col, init_val, direction)
  #   @param [Integer] n_times How many cols to add.
  #   @param [Integer] from_col Index to start expansion from.
  #   @param [Integer] init_val Init value (Integer).
  #   @param [Integer] direction 0: right, -1: left.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times col(s) from_col, filled with init_val,
  #   after or before the from_col index, according to the value of direction (0 for after, -1 for before).
  #
  # @overload add_col(n_times, from_col, src_array, direction)
  #   @param [Integer] n_times How many cols to add.
  #   @param [Integer] from_row Index to start expansion from.
  #   @param [Integer] src_array Injecting array of Integers.
  #   @param [Integer] direction 0: right, -1: left.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times src_array(s) from_col,
  #   after or before the from_col index, according to the value of direction (0 for after, -1 for before).
  #
  #
  # @note: WARN: When an out-of-range upper index is given, the default behaviour will be to 
  #  set the index to the grid upper-one, and proceed from there.
  #  *NO exceptions will raise for this.*
  #
  #
  # @raise [ArgumentError] If something is wrong with them.
  #
  def add_col(*args)
    case args.size
    when 2..4
      raise ArgumentError, 'Argument type(s) is not Integer' unless args.each { |a| a.is_a? Integer }
      raise ArgumentError, 'Argument(s) (: 1, 2, 3) cannot be negative Integer(s)'  unless args.each_with_index { |a,i| a.class != Array && ( a >= 0 && i < 3 ) }
      raise ArgumentError, 'Argument (: position) shall be in range [-1,0]' unless  args.size < 4 || (args.size == 4 && args[3].to_i.between?(-1,0))
   
      count = args.first.to_i
      position = args[1].to_i
      val = args.size == 2 ? 0 : args[2].class == Array ? args[2].to_a : args[2].to_i
      side = args.size == 3 ? 0 : args[3].to_i
      i = side == -1 ? 0 : 1
      position = position < @cols-1 ? position : @cols-1 # ensure upper limit if out-of-range
 
      count.times {
        j = 0
        @grid.each { |row|
          if j < @rows
            inj_val = val.class == Array ? val[j] : val
            row.insert(position+i, inj_val)
            j += 1
          end
        }
      }
 
      @cols += count
      @grid
    else
      raise ArgumentError, 'Argument number (#{args.size}) is wrong'
    end
  end

  ###### Grid columns collapse

  #
  #
  # @overload del_col(n_times, from_col)
  #   @return [Array<Integer>, Array[Integer]] Grid with removed n_times col(s) *after* from_col.
  #
  # @overload del_col(n_times, from_col, direction)
  #   @return [Array<Integer>, Array[Integer]] Grid with removed n_times col(s) from_col,
  #   after or before the from_col index, according to the value of direction (0 for after, -1 for before).
  #
  #
  # @note: WARN: When an out-of-range upper index is given, the default behaviour will be to 
  #  simply return the original grid without any modification.
  # @note: WARN: By default this function will try to process as many n_times possible,
  #  that is, if n_times exceeds the room available, it will will set n_times to the max room.
  #  If there is no room, it will return the grid untouched.
  #
  #
  # @param [Integer] n_times How many cols to remove.
  # @param [Integer] from_col Index to start collapsing from.
  # @param [Integer] direction (optional) 0: right, -1: left.
  # @raise [ArgumentError] if something is wrong with them.
  #
  def del_col(*args)
    case args.size
    when 2..3
      raise ArgumentError, 'Argument type(s) is not Integer' unless args.each { |a| a.is_a? Integer }
      raise ArgumentError, 'Argument(s) (: 1, 2) cannot be negative Integer(s)' unless args.each_with_index { |a,i| a >= 0 && i < 2 }
      raise ArgumentError, 'Argument (: position) shall be in range [-1,0]' unless  args.size < 3 || (args.size == 3 && args[2].to_i.between?(-1,0))
      count = args.first.to_i
      position = args[1].to_i
      side = args.size == 2 ? 0 : args[2].to_i

      # enough room there?
      room = @cols-position
  
      if side == 0
        count = room > 0 ? (count > room ? room : count) : 0
      elsif side == -1
        count = room < 0 ? 0 : count > room ? room : count
      end 

      @grid.each { |row|
        i = 0
        count.times {
          row.delete_at(position-i)
          i += 1 if side == -1 && position-i >= 0 # ensure lower boundary is safe
        }
      }
      @cols -= count
      @grid
    else
      raise ArgumentError, 'Argument type(s) is not Integer' unless args.each { |a| a.is_a? Integer }
    end
  end

  ###### Fast pickings

  # NOTE: not overloading for now
  def pick_row(index)
    raise ArgumentError, 'Argument (: index) is out of range' unless  index < @rows
    @grid[index]
  end

  # NOTE: not overloading for now
  def pick_col(index)
    raise ArgumentError, 'Argument (: index) is out of range' unless  index < @cols
    buf = []
    @grid.each { |row| 
      buf << row[index]
    }
    buf
  end


  ###### Injection aliases

  # WARN: Injections will consider the passed index as the very first position to inject,
  # while using add_row or add_col you will always access the position after or before the given index.
  #
  # Consequence: use inject_row / inject_col when you need to start overwriting a precise index,
  # use add_row / add_col when you need to perform generic additions right after / before an index.
  #
  # You have been warned.

  # NOTE: not overloading for now, fixed mandatory arguments number
  # WARN: when using inject_*, you are forced to indicate a direction (0: right, -1: left)

  def inject_row(n_times, from_row, src_array, direction)
    case direction
    when 0
      add_row(1, from_row, src_array, -1)
      add_row(n_times-1, from_row, src_array, 0) unless n_times-1 > 0
    when -1
      add_row(1, from_row, src_array, 0)
      add_row(n_times-1, from_row, src_array, -1) unless n_times-1 > 0
    else
      raise ArgumentError, 'Argument number (#{args.size}) is wrong'
    end
  end

  # NOTE: not overloading for now
  def inject_col(n_times, from_col, src_array, direction)
    case direction
    when 0
      add_col(1, from_col, src_array, -1)
      add_col(n_times-1, from_col, src_array, 0) unless n_times-1 > 0
    when -1
      add_col(1, from_col, src_array, 0)
      add_col(n_times-1, from_col, src_array, -1) unless n_times-1 > 0
    else
      raise ArgumentError, 'Argument number (#{args.size}) is wrong'
    end
  end


  ###### Swapping
  def swap_rows(idx_a, idx_b)
    row_a = pick_row(idx_a)
    row_b = pick_row(idx_b)
    del_row(1, idx_a)
    add_row(1, idx_a, row_b, -1)
    del_row(1, idx_b)
    add_row(1, idx_b, row_a, -1)
  end

  def swap_cols(idx_a, idx_b)
    col_a = pick_col(idx_a)
    col_b = pick_col(idx_b)
    del_col(1, idx_a)
    add_col(1, idx_a, col_b, -1)
    del_col(1, idx_b)
    add_col(1, idx_b, col_a, -1)
  end


end
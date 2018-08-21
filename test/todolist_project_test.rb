require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/reporters'
require 'date'


Minitest::Reporters.use!

require_relative '../lib/todolist_project'

class TodoListTest < MiniTest::Test
  def setup
    @todo1 = Todo.new('Buy milk')
    @todo2 = Todo.new('Clean room')
    @todo3 = Todo.new('Go to gym')
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_item_change_title
    @todo1.title = 'Buy milk and cheese'
    expected = 'Buy milk and cheese'
    assert_equal(expected, @todo1.title)
  end

  def test_item_empty_description
    assert_equal('', @todo1.description)
  end

  def test_item_description_assignment
    @todo1.description = 'Buy whole milk from Safeway on 1st' 
    expected = 'Buy whole milk from Safeway on 1st'
    assert_equal(expected, @todo1.description)
  end

  def test_item_done_defaults_to_false
    assert_equal(false, @todo1.done)
  end

  def test_item_due_date_defaults_to_empty
    assert_nil(@todo1.due_date)
  end

  def test_due_date
    due_date = Date.today + 3
    @todo2.due_date = due_date
    assert_equal(due_date, @todo2.due_date)
  end

  def test_raises_type_error_unless_date
    assert_raises(TypeError) { @todo1.due_date = '1/2/2012' }
  end

  def test_raises_argument_error_if_date_passed
    assert_raises(ArgumentError) { @todo1.due_date = Date.new(2017, 05, 03) }
  end

  def test_no_error_if_date_today
    @todo1.due_date = Date.today
    assert_equal(Date.today, @todo1.due_date)
  end

  def test_item_done
    @todo1.done!
    assert_equal(true, @todo1.done)
  end

  def test_item_undone!
    @todo1.done!
    assert_equal(true, @todo1.done)
    @todo1.undone!
    assert_equal(false, @todo1.done)
  end

  def test_item_done?
    assert_equal(false, @todo1.done?)
    @todo1.done!
    assert_equal(true, @todo1.done?)
  end

  def test_item_to_s_undone
    expected_str = '[ ] Buy milk'
    assert_equal(expected_str, @todo1.to_s)
  end

  def test_item_to_s_done
    expected_str = '[X] Buy milk'
    @todo1.done!
    assert_equal(expected_str, @todo1.to_s)
  end

  def test_item_to_s_with_due_date_undone
    @todo1.due_date = Date.new(2099, 4, 15)
    expected_str = '[ ] Buy milk (Due: Wednesday April 15)'
    assert_equal(expected_str, @todo1.to_s)
  end

  def test_item_to_s_with_due_date_done
    @todo1.due_date = Date.new(2099, 4, 15)
    expected_str = '[X] Buy milk (Due: Wednesday April 15)'
    @todo1.done!
    assert_equal(expected_str, @todo1.to_s)
  end

  def test_title
    expected = "Today's Todos"
    assert_equal(expected, @list.title)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_add_raise_error_integer
    assert_raises(TypeError) { @list.add(1) }
  end

  def test_add_raise_error_string
    assert_raises(TypeError) { @list.add('hi') }
  end

  def test_add_alias
    new_todo = Todo.new('Walk the dog')
    @list.add(new_todo)
    todos = @todos << new_todo

    assert_equal(todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    todo = @list.shift
    assert_equal(@todo1, todo)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    todo = @list.pop
    assert_equal(@todo3, todo)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done_question
    assert_equal(false, @list.done?)
  end

  def test_item_at
    assert_raises(IndexError) { @list.item_at(100) }
    assert_equal(@todo1, @list.item_at(0))
    assert_equal(@todo2, @list.item_at(1))
  end

  def test_find_by_title
    todo = @list.find_by_title('Buy milk')
    assert_equal(@todo1, todo)
  end

  def test_all_done
    @todo1.done!
    @todo3.done!
    assert_equal([@todo1, @todo3], @list.all_done.to_a)
  end

  def test_all_not_done
    @todo2.done!
    assert_equal([@todo1, @todo3], @list.all_not_done.to_a)
  end

  def test_mark_done_by_title
    @list.mark_done('Go to gym')
    assert_equal(true, @todo3.done?)
  end

  def test_mark_all_done
    @list.mark_all_done
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
    assert_equal(true, @list.done?)
  end

  def test_mark_all_undone
    @list.mark_all_done
    @list.mark_all_undone
    assert_equal(false, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(false, @todo3.done?)
    assert_equal(false, @list.done?)
  end

  def test_mark_done_at
    assert_raises(IndexError) { @list.mark_done_at(100) }
    @list.mark_done_at(1)
    assert_equal(false, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(false, @todo3.done?)
  end

  def test_mark_undone_at
    assert_raises(IndexError) { @list.mark_undone_at(100) }
    @todo1.done!
    @todo2.done!
    @todo3.done!

    @list.mark_undone_at(1)

    assert_equal(true, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(true, @todo3.done?)
  end

  def test_done_bang
    @list.done!
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
    assert_equal(true, @list.done?)
  end

  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(100) }
    @list.remove_at(1)
    assert_equal([@todo1, @todo3], @list.to_a)
  end

  def test_to_s
    output = <<-OUTPUT.chomp.gsub(/^\s+/, '')
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_2
    output = <<-OUTPUT.chomp.gsub(/^\s+/, '')
    ---- Today's Todos ----
    [ ] Buy milk
    [X] Clean room
    [ ] Go to gym
    OUTPUT

    @list.mark_done_at(1)
    assert_equal(output, @list.to_s)
  end

  def test_to_s_3
    output = <<-OUTPUT.chomp.gsub(/^\s+/, '')
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    @list.done!
    assert_equal(output, @list.to_s)
  end

  def test_each
    result = []
    @list.each { |todo| result << todo }
    assert_equal([@todo1, @todo2, @todo3], result)
  end

  def test_each_returns_original_list
    assert_equal(@list, @list.each {|todo| nil })
  end

  def test_select
    @todo1.done!
    list = TodoList.new(@list.title)
    list.add(@todo1)

    assert_equal(list.title, @list.title)
    assert_equal(list.to_s, @list.select{ |todo| todo.done? }.to_s)
  end

  def test_to_s_with_due_date
    @todo2.due_date = Date.new(2099, 4, 15)
    output = <<-OUTPUT.chomp.gsub(/^\s+/,'')
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room (Due: Wednesday April 15)
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end
end
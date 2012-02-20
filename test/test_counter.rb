require 'test/unit'

require 'stubb'

class TestCounter < Test::Unit::TestCase

  def setup
    @env = Rack::MockRequest.env_for '/request/path'
    @counter = Stubb::Counter.new lambda { |env| [200, {}, [env['stubb.request_sequence_index']]] }
  end

  def test_initial_request
    result = @counter.call(@env)
    assert_equal 1, @env['stubb.request_sequence_index']
    assert_equal result.last.last, @env['stubb.request_sequence_index']
  end

  def test_repeated_request
    @counter.call(@env)
    result = @counter.call(@env)
    assert_equal 2, result.last.last
  end

  def test_side_effects
    @counter.call(@env)
    result = @counter.call Rack::MockRequest.env_for('/request/other')
    assert_equal 1, result.last.last
  end

end


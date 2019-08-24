require 'minitest/autorun'
require_relative 'simple_db'

class TestSimpleDb < Minitest::Test

  def test_exists?
    db = SimpleDb.new
    refute db.exists?("a")
  end

  def test_get
    db = SimpleDb.new
    refute db.get("a")
  end

  def test_get_and_set
    db = SimpleDb.new
    db.set("a", 1)
    assert_equal(db.get("a"), 1)
  end

  def test_set_and_unset
    db = SimpleDb.new

    db.set("a", 1)
    assert_equal(db.get("a"), 1)

    db.unset("a")
    assert_nil(db.get("a"))
  end

  def test_begin
    db = SimpleDb.new

    db.set("a", 1)
    db.begin
    db.set("a", 2)
    db.set("b", 3)

    assert_equal(db.get("a"), 2)
    assert_equal(db.get("b"), 3)
  end

  def test_commit
    db = SimpleDb.new

    db.set("a", 1)
    db.set("b", 2)

    db.begin
    db.set("a", 3)
    db.unset("b")
    db.commit

    assert_equal(db.get("a"), 3)
    assert_nil(db.get("b"))
  end

  def test_rollback
    db = SimpleDb.new

    db.set("a", 1)

    db.begin
    db.set("a", 2)
    db.set("b", 3)

    db.commit
    assert_equal(db.get("a"), 2)
    assert_equal(db.get("b"), 3)

    db.rollback
    assert_equal(db.get("a"), 1)
    assert_nil(db.get("b"))
  end

  def test_nested_transactions
    db = SimpleDb.new

    db.set("a", 1)

    db.begin
    db.set("a", 2)
    db.set("b", 3)

    db.begin
    db.set("a", 4)
    db.set("b", 5)

    db.commit
    assert_equal(db.get("a"), 4)
    assert_equal(db.get("b"), 5)
  end

  def test_nested_transactions_and_multiple_rollbacks
    db = SimpleDb.new

    db.set("a", 1)

    db.begin
    db.set("a", 2)
    db.set("b", 3)

    db.begin
    db.set("a", 4)
    db.set("b", 5)

    db.commit
    assert_equal(db.get("a"), 4)
    assert_equal(db.get("b"), 5)

    db.rollback
    assert_equal(db.get("a"), 2)
    assert_equal(db.get("b"), 3)

    db.rollback
    assert_equal(db.get("a"), 1)
    assert_nil(db.get("b"))
  end
end

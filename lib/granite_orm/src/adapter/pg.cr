require "./base"
require "pg"

# PostgreSQL implementation of the Adapter
class Granite::Adapter::Pg < Granite::Adapter::Base
  # remove all rows from a table and reset the counter on the id.
  def clear(table_name)
    open do |db|
      db.exec "DELETE FROM #{table_name}"
    end
  end

  # select performs a query against a table.  The table_name and fields are
  # configured using the sql_mapping directive in your model.  The clause and
  # params is the query and params that is passed in via .all() method
  def select(table_name, fields, clause = "", params = [] of DB::Any, &block)
    clause = _ensure_clause_template(clause)

    statement = String.build do |stmt|
      stmt << "SELECT "
      stmt << fields.map { |name| "#{table_name}.#{name}" }.join(",")
      stmt << " FROM #{table_name} #{clause}"
    end
    open do |db|
      db.query statement, params do |rs|
        yield rs
      end
    end
  end

  # select_one is used by the find method.
  def select_one(table_name, fields, field, id, &block)
    statement = String.build do |stmt|
      stmt << "SELECT "
      stmt << fields.map { |name| "#{table_name}.#{name}" }.join(",")
      stmt << " FROM #{table_name}"
      stmt << " WHERE #{field}=$1 LIMIT 1"
    end
    open do |db|
      db.query_one? statement, id do |rs|
        yield rs
      end
    end
  end

  def insert(table_name, fields, params)
    statement = String.build do |stmt|
      stmt << "INSERT INTO #{table_name} ("
      stmt << fields.map { |name| "#{name}" }.join(",")
      stmt << ") VALUES ("
      stmt << fields.map { |name| "$#{fields.index(name).not_nil! + 1}" }.join(",")
      stmt << ")"
    end
    open do |db|
      db.exec statement, params
      return db.scalar(last_val()).as(Int64)
    end
  end

  private def last_val
    return "SELECT LASTVAL()"
  end

  # This will update a row in the database.
  def update(table_name, primary_name, fields, params)
    statement = String.build do |stmt|
      stmt << "UPDATE #{table_name} SET "
      stmt << fields.map { |name| "#{name}=$#{fields.index(name).not_nil! + 1}" }.join(",")
      stmt << " WHERE #{primary_name}=$#{fields.size + 1}"
    end
    open do |db|
      db.exec statement, params
    end
  end

  # This will delete a row from the database.
  def delete(table_name, primary_name, value)
    open do |db|
      db.exec "DELETE FROM #{table_name} WHERE #{primary_name}=$1", value
    end
  end

  private def _ensure_clause_template(clause)
    if clause.includes?("?")
      num_subs = clause.count("?")

      num_subs.times do |i|
        clause = clause.sub("?", "$#{i + 1}")
      end
    end

    clause
  end
end

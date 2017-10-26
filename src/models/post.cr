require "granite_orm/adapter/pg"

class Post < Granite::ORM::Base
  adapter pg

  belongs_to :user
  # id : Int64 primary key is created for you
  field title : String
  field body : String
  field published : Bool
  timestamps
end

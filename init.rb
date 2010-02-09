# Include hook code here
require "enum_column"
require "enum_column_helper"
ActiveRecord::Base.send(:include, EnumColumn)

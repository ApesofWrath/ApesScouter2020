# Copyright 2019
# The Apes of Wrath
#
# @author Cody King
# cking@apesofwrath668.org
#
# Connection for database

DB = Sequel.mysql2({ :host => 'localhost', :user => 'pi', :password => ENV.fetch('DB_PASS'), :database => 'scouting_data' })

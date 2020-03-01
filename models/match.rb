# Copyright 2019
# The Apes of Wrath
#
# @author Cody King
# cking@apesofwrath668.org

class Match < Sequel::Model(:matches)
    many_to_one :competitions      
end

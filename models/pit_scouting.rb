# Copyright 2019
# The Apes of Wrath
#
# @author Cody King
# cking@apesofwrath668.org

class Pit_Scouting < Sequel::Model(:pit_scouting)
    many_to_one :competitions
end

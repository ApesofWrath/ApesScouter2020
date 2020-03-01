# Copyright 2019
# The Apes of Wrath
#
# @author Cody King
# cking@apesofwrath668.org

class Team < Sequel::Model(:teams)
    many_to_one :competitions

    Team.unrestrict_primary_key
end

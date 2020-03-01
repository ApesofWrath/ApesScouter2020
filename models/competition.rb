# Copyright 2019
# The Apes of Wrath
#
# @author Cody King
# cking@apesofwrath668.org

class Competition < Sequel::Model(:competitions)
    one_to_many :matches      
end

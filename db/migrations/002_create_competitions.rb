# Copyright 2019
# The Apes of Wrath
#
# @author Cody King
# cking@apesofwrath668.org

Sequel.migration do
    change do
        create_table(:competitions) do
            primary_key :id
            String :name, :null => false
            Integer :year, :null => false
        end
    end
end


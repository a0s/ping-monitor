class Event < Sequel::Model
  plugin :single_table_inheritance, :type,
         :model_map => {1 => :Enable, 2 => :Statistic, 3 => :Fail, 4 => :Disable}
  many_to_one :ip
end

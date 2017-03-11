class Event < Sequel::Model
  plugin :single_table_inheritance, :type,
         :model_map => {1 => :Enable, 2 => :Statistic, 3 => :Fail, 4 => :Disable}
  many_to_one :ip

  subset(:stat_or_fail) do
    sti = Event.sti_model_map.invert
    {type: [sti[:Statistic], sti[:Fail]]}
  end
end

# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :ips do
      primary_key :id
      inet :ip, unique: true, null: false
      Boolean :enabled
      Time :last_checked_at, index: true, null: false, default: Time.at(0)
      Time :start_checking_at, index: true, null: true
    end
  end
end

# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :ips do
      primary_key :id
      inet :ip, null: false, unique: true
      Boolean :enabled, null: false, default: false, index: true
      Time :last_checked_at, null: false, default: Time.at(0), index: true
      Time :start_checking_at, null: true, index: true
    end
  end
end

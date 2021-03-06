# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :events do
      primary_key :id
      foreign_key :ip_id, null: false
      Integer :type, index: true, null: false
      Time :created_at, null: false
      Float :latency, index: true
    end
  end
end

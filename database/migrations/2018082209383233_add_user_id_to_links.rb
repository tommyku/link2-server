Sequel.migration do
  up do
    alter_table(:links) do
      add_foreign_key :user_id, :users, on_delete: :cascade
      add_index %i[id user_id]
    end
  end

  down do
    alter_table(:links) do
      drop_foreign_key :user_id
      drop_index %i[id user_od]
    end
  end
end

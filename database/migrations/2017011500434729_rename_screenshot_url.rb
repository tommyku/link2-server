Sequel.migration do
  up do
    alter_table(:links) do
      rename_column :screenshot_url, :screenshot_uuid
    end
  end

  down do
    alter_table(:links) do
      rename_column :screenshot_uuid, :screenshot_url
    end
  end
end

Sequel.migration do
  up do
    create_table(:links) do
      primary_key :id
      String :title
      String :details, text: true
      String :url
      String :tags
      String :screenshot_url
      Integer :bounce, default: 0
      DataTime :created_at
    end
  end

  down do
    drop_table(:links)
  end
end

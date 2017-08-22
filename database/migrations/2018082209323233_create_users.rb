Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :username, unique: true
      String :email, unique: true
      String :password_digest
      index :username
    end
  end

  down do
    drop_table(:users)
  end
end

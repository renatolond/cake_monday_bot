ROM::SQL.migration do
  change do
    create_table :candidates do
      primary_key :id
      column :name, :varchar, null: false
      column :available, :boolean, null: false
    end
  end
end

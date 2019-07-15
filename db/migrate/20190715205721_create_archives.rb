ROM::SQL.migration do
  change do
    create_table :archives do
      primary_key :id
      foreign_key :candidate_id, :candidates, null: false
      column :drawn_at, :date, null: false
      index :drawn_at
    end
  end
end

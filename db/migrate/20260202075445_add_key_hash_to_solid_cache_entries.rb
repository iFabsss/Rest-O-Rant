class AddKeyHashToSolidCacheEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :solid_cache_entries, :key_hash, :string
    add_index :solid_cache_entries, :key_hash
  end
end

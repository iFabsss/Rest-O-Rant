class AddUniqueIndexToSolidCacheEntriesKeyHash < ActiveRecord::Migration[7.0]
  def change
    add_index :solid_cache_entries, :key_hash, unique: true
  end
end

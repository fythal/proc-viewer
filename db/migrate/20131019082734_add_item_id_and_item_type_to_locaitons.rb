class AddItemIdAndItemTypeToLocaitons < ActiveRecord::Migration
  def up
    change_table(:locations) do |t|
      t.integer :item_id
      t.string  :item_type
    end

    Location.where('ann_id is not null').each do |loc|
      loc.item_id = loc.ann_id
      loc.item_type = 'Ann'
      loc.save
    end

    change_table(:locations) do |t|
      t.remove :ann_id
    end
  end

  def down
    change_table(:locations) do |t|
      t.integer :ann_id
    end

    Location.where('item_type = "Ann"').each do |loc|
      loc.ann_id = loc.item_id
      loc.save
    end

    change_table(:locations) do |t|
      t.remove :item_id, :item_type
    end
  end
end

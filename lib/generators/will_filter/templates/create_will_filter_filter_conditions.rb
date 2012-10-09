class CreateWillFilterFilterConditions < ActiveRecord::Migration
  def change
    create_table :will_filter_filter_conditions do |t|
      t.string      :type
      t.string      :operator
      t.string      :container_type
      t.string      :key
      t.text        :values
      t.integer     :will_filter_filter_id
    end

    add_index :will_filter_filters_conditions, :will_filter_filter_id
  end
end

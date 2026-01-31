class CreateAppInfos < ActiveRecord::Migration[8.1]
  def change
    create_table :app_infos do |t|
      t.string :app_name

      t.timestamps
    end
  end
end

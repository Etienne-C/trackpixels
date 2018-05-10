class CreatePixels < ActiveRecord::Migration[5.1]
  def change
    create_table :pixels do |t|
      t.string :ip_address
      t.string :campaign
      t.string :content_type
      t.string :city
      t.string :state
      t.string :user_agent
      t.string :referral
      t.string :banner_size

      t.timestamps
    end
  end
end

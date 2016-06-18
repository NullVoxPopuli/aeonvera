class CreateSponsorships < ActiveRecord::Migration
  def change
    create_table :sponsorships do |t|
      t.integer :discount_amount, null: false, default: 0
      t.references :sponsor, polymorphic: true, index: true
      t.references :sponsored, polymorphic: true, index: true

      t.timestamps null: false
    end


  end
end

class SetPurchaseStartingId < ActiveRecord::Migration
  def up
    execute("ALTER SEQUENCE purchases_id_seq RESTART 261202");
  end

  def down
  end
end

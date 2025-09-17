class BackfillWarningsCountOnUsers < ActiveRecord::Migration[6.1]
  def up
    User.update_all(warnings_count: 0)
  end

  def down
    # No-op
  end
end

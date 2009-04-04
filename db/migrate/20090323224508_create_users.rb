class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column    :id, 'serial'
      t.column    :login, 'character varying(20)'
      t.string    :password_hash, :salt
      t.boolean   :guest, :null => false, :default => false
      t.column    :email, 'character varying(100)'
      t.boolean   :admin, :null => false, :default => false
      t.timestamps :null => false
    end
    constrain :users do |t|
      t.login :length_within => 4..20, :unique => true
      t.email :length_within => 5..100, :not_blank => true
    end
    execute %{
      CREATE FUNCTION clean_guests() RETURNS trigger AS $clean_guests$
          BEGIN
              DELETE FROM users WHERE AGE(updated_at) > '24 hours' AND guest = true;
              RETURN NEW;
          END;
      $clean_guests$ LANGUAGE plpgsql;

      CREATE TRIGGER clean_guests AFTER INSERT ON users
          FOR STATEMENT EXECUTE PROCEDURE clean_guests();
    }
    User.new(:login => "admin", :password => "admin", :password_confirmation=>"admin", :email => "mikz@mailinator.com"){|r| r.admin = true }.save_without_validation
  end

  def self.down
    execute "DROP FUNCTION IF EXISTS clean_guests() CASCADE;"
    execute "DROP TABLE IF EXISTS users CASCADE;"
  end
end

class CreatePosts < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
  		t.text :content
  		t.text :author
  		t.timestamps
  	end
  
create_table :comments do |t|
  		t.belongs_to :post, index: true
  		t.text :content
  		t.timestamps
  	end


  end
end

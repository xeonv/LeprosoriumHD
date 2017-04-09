#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'sinatra/activerecord'
set:database, "sqlite3:leprosorium.db"

class Post<ActiveRecord::Base
end
class Comment<ActiveRecord::Base
end




before do
@posts = Post.order "created_at DESC"
end

# configure do

# end

get '/' do
	erb :index			
end

get '/new' do
   erb :new
end

post '/new' do
   p = Post.new params[:post]
   p.save
   erb "You typed: #{p.content} , author #{p.author}"
end

get '/details/:id' do
	post_id = params[:id]

	results = @db.execute 'select * from Posts where id=?', [post_id]
		@row = results [0]
	@comments = @db.execute 'select * from Comments  where post_id=? order by id', [post_id]
	erb :details
end

post '/details/:id' do
	post_id = params[:id]
	content = params[:content]
   		if content.length <= 0
   			@error = "Type comment!"
   			results = @db.execute 'select * from Posts where id=?', [post_id]
			@row = results [0]
			@comments = @db.execute 'select * from Comments  where post_id=? order by id', [post_id]
   			 return erb :details
   			
   		end
   		@db.execute 'INSERT INTO Comments (content, created_date, post_id) values (?, datetime (),?)', [content, post_id]
  
   	redirect to ('/details/' + post_id)
end
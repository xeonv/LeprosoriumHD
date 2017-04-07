#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db=SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do
init_db
end

configure do
	init_db
  @db.execute 'CREATE TABLE IF NOT EXISTS Posts (id INTEGER PRIMARY KEY AUTOINCREMENT, created_date DATE, content TEXT, author TEXT )'
  @db.execute 'CREATE TABLE IF NOT EXISTS Comments (id INTEGER PRIMARY KEY AUTOINCREMENT, created_date DATE, content TEXT, post_id INTEGER)'
end

get '/' do
	@results = @db.execute 'select * from Posts order by id desc'
	erb :index			
end

get '/new' do
   erb :new
end

post '/new' do
   content = params[:content]
   author = params[:author]
   		if content.length <= 0
   			@error = "Type post text"
   				return erb :new
   		end
   	@db.execute 'INSERT INTO Posts (content, created_date, author) values (?, datetime (),?)', [content, author]
   erb "You typed: #{content} , author #{author}"
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
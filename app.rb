#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
 
 def init_db
 	@db = SQLite3::Database.new 'Habrara.db'
 	@db.results_as_hash = true
 end

# before вызывается каждый раз при перезагрузке
# любой страницы
 before do

 	# инициализация БД
 	
 	init_db
 end

# configure вызывается каждый раз при конфигурации приложения:
# когда изменился код программы и перезагрузилась страница
 configure do

 	# инициализация БД

 	init_db

 	#создает таблицу Posts

 	@db.execute 'CREATE TABLE Posts
 	(
	 	id INTEGER PRIMARY KEY AUTOINCREMENT,
	 	created_date DATE,
	 	content TEXT
 	)'
 end
get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

# обработчик get- запроса /new
# (барузер получает страницу с сервера)

get '/new' do
  erb :new
end

# обработчик poct-запроса/new
# (браузер отправляет данные на сервер)

post '/new' do
	# получаем переменную  из Post запроса
  	content = params[:content]

  	erb "You typed #{content}"
end
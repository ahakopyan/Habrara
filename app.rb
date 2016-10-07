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

 	@db.execute 'create table if not exists Posts
 	(
	 	id INTEGER PRIMARY KEY AUTOINCREMENT,
	 	created_date DATE,
	 	content TEXT
 	)'
 end

get '/' do
	# выбираем список постов из БД
    @results = @db.execute 'select * from Posts order by id desc'
	erb :index
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

  	if content.length <= 0
  		@error = "Type post text"
  		return erb :new
  	end

  	# сохранение данных в БД
  	@db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content]

  	redirect to '/'
end

# вывод информации о посте

get '/details/:id' do
	post_id = params[:post_id]
	erb "Displaying information for post with id #{post_id}"
end
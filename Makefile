help:  ##show this help
	@fgrep -h 


catalogue:  ##Installing catalogue
	@bash Components/catalogue.sh	
	
mongodb:  ##Installing mongodb
	@bash Components/mongodb.sh	
	
redis:  ##Installing redis
	@bash Components/redis.sh
	
user:  ##Installing user
	@bash Components/user.sh
	
cart:  ##Installing cart
	@bash Components/cart.sh
	
mysql:  ##Installing mysql
	@bash Components/mysql.sh
	
shipping:  ##Installing shipping
	@bash Components/shipping.sh
	
rabbitmq:  ##Installing rabbitmq
	@bash Components/rabbitmq.sh
	
payment:  ##Installing payment
	@bash Components/payment.sh
	
frontend:  ##Installing frontend
	@bash Components/frontend.sh
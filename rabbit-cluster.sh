docker volume create rabbitmq_data -d "local"
docker volume create rabbitmq_log -d "local"
docker network create rabbitmq -d "bridge"

docker run -d -h node-1.rabbitmq \
    --name rabbitmq \
    -p "127.0.0.1:4369:4369" \
    -p "127.0.0.1:5672:5672" \
    -p "127.0.0.1:25672:25672" \
    -p "127.0.0.1:35197:35197" \
    -p "127.0.0.1:15672:15672" \
    --expose "5672" \
    --network rabbitmq \
    -e "RABBITMQ_USE_LONGNAME=true" \
    -e "RABBITMQ_LOGS=/var/log/rabbitmq/rabbit.log" \
    -v rabbitmq_data:/var/lib/rabbitmq \
    -v rabbitmq_log:/var/log/rabbitmq \
    -v /var/projects/docker-elk/rabbitmq/config/rabbitmq.config:/etc/rabbitmq/rabbitmq.config \
    -v /var/projects/docker-elk/rabbitmq/config/rabbit.json:/etc/rabbitmq/rabbit.json \
    rabbitmq:3.6.6-management

sleep 10

docker exec rabbitmq rabbitmqctl delete_user guest

docker exec rabbitmq rabbitmqctl add_vhost /

docker exec rabbitmq rabbitmqctl add_user mobium lines4141
docker exec rabbitmq rabbitmqctl set_user_tags mobium administrator


docker exec rabbitmq rabbitmqctl add_user mobium_app WhoIsFirst
docker exec rabbitmq rabbitmqctl set_permissions -p / mobium_app ".*" ".*" ".*"
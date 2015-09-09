# C6POCDemo
Package all dependancies of the Docker based MT poc into single pack

# Howto build 

./make
it will download all dependancies and create c6pocdemo.tgz

# Howto run the app

mkdir demo
tar zxvf c6pocdemo.tgz -c demo
cd demo
./server.sh start|stop

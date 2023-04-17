# Choice of the base image on which to build each container

- I used yolo so as to match the project work and get a flow.

## Dockerfile directives used in the creation and running of each container

i. node:13.12.0-alpine
ii. npm dependencies
iii. package* jonson.json
iv. port 3000 & 5000

### Docker-compose Networking (Application port allocation and a bridge network implementation) where necessary 

- Use yolo-test-network & ip4 address
- mongodb url
- docker-compose yaml file

## Docker-compose volume definition and usage (where necessary)

- use yolo container.

## Git workflow used to achieve the task

- shared repo in 'https://github.com/OleShangti/yolo'

## Successful running of the applications and if not, debugging measures applied

- Runned successfull used docker-compose up to test

- Pushed to docker hub 'https://hub.docker.com/'

## Good practices such as Docker image tag naming standards for ease of identification of images and containers. 

- images used and tagging:

yolo-frontend            latest    034c3c0c7095   4 hours ago   366MB
jshangiti/yolo-client    1.0.0     e79bd4009120   4 hours ago   366MB
yolo-client              1.0.0     e79bd4009120   4 hours ago   366MB
jshangiti/yolo-backend   1.0.0     4dd7861a218e   4 hours ago   187MB
yolo-backend             1.0.0     4dd7861a218e   4 hours ago   187MB
mongo                    latest    9a5e0d0cf6de   4 weeks ago   646MB
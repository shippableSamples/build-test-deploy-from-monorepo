#!/bin/bash -e
export IMAGE_NAME=foo/api
export RES_IMAGE="api-img"
export RES_DOCKERHUB_INTEGRATION=dockerhub

check_jq() {
  {
    type jq &> /dev/null && echo "jq is already installed"
  } || {
    echo "Installing 'jq'"
    echo "----------------------------------------------"
    apt-get install -y jq
  }
}


dockerhub_login() {
  echo "Logging in to Dockerhub"
  echo "----------------------------------------------"

  local creds_path="/build/IN/$RES_DOCKERHUB_INTEGRATION/integration.json"

  find -L "/build/IN/$RES_DOCKERHUB_INTEGRATION"
  local username=$(cat $creds_path \
    | jq -r '.username')
  local password=$(cat $creds_path \
    | jq -r '.password')
  local email=$(cat $creds_path \
    | jq -r '.email')
  echo "######### LOGIN: $username"
  echo "######### EMAIL: $email"
  sudo docker login -u $username -p $password -e $email
}

create_image_version() {
  echo "Creating a state file for" $RES_IMAGE
  echo versionName=$SHIPPABLE_BUILD_NUMBER.$((SHIPPABLE_JOB_ID)) > /build/state/$RES_IMAGE.env
  echo SHIPPABLE_BUILD_NUMBER=$((SHIPPABLE_BUILD_NUMBER)) >> /build/state/$RES_IMAGE.env
  echo "Completed creating a state file for" $RES_IMAGE
}

run() {
	sudo npm install
	grunt
	ret="$?"
	if [ "$ret" == 0 ]; then
	    echo "Building image $1"
	    sudo docker build -t $IMAGE_NAME:$BRANCH.$SHIPPABLE_BUILD_NUMBER .
	    echo "pushing image $1"
	    #sudo docker push $IMAGE_NAME:$1.$BRANCH.$SHIPPABLE_BUILD_NUMBER
	    create_image_version
	else
		exit "$ret"
	fi
}

main() {
	check_jq
	dockerhub_login
	run
}

main "$@"

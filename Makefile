all:
    AWS_REGION=us-east-2
    AWS_ACCOUNT_ID=<MY-ID-NUMBER>
    AWS_BUCKET=my-jenkins-base-jenkinsbucket-butp1yp6hjv3

    JENKINS_REPO=jenkins_repository
    JENKINS_IMAGE=latest
    JENKINS_BASE=my-jenkins-base
    JENKINS_SERVICE=my-jenkins-service
    JENKINS_ECS_CLUSTER_INSTANCE_TYPE=t2.micro

base: .
	aws cloudformation create-stack --stack-name ${JENKINS_BASE} --template-body file://./base-resources/template.yaml --capabilities "CAPABILITY_NAMED_IAM" --region ${AWS_REGION}

image: .
	@printf "Building Jenkins' Docker...\n"
	docker build -t my_jenkins .

	@printf "\n"
	@printf "Tagging the image with the AWS Repository\n"
	docker tag my_jenkins ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${JENKINS_REPO}

	@printf "\n"
	@printf "Login in AWS ECR\n"
	@eval $(aws ecr get-login --no-include-email --registry-ids ${AWS_ACCOUNT_ID} --region ${AWS_REGION})

	@printf "\n"
	@printf "Pushing the image to ECR\n"
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${JENKINS_REPO}

create-stack: .
	@printf "Updating the .yaml files to the S3 Bucket...\n"
	@printf "\n"
	aws s3 sync ./cloudformation-stack s3://${AWS_BUCKET} --exclude "*" --include "*.yaml"
	@printf "\n"

	@printf "Creating the Service Stack...\n"
	@printf "\n"
	aws cloudformation create-stack --stack-name ${JENKINS_SERVICE} --template-url https://s3.amazonaws.com/${AWS_BUCKET}/master.yaml --capabilities "CAPABILITY_NAMED_IAM" --region ${AWS_REGION} --parameters ParameterKey=ECSClusterInstanceType,ParameterValue=${JENKINS_ECS_CLUSTER_INSTANCE_TYPE} ParameterKey=JenkinsImageTag,ParameterValue=${JENKINS_IMAGE} ParameterKey=JenkinsRepository,ParameterValue=${JENKINS_REPO} ParameterKey=BucketName,ParameterValue=${AWS_BUCKET}

update-stack: .
	@printf "Updating the .yaml files to the S3 Bucket...\n"
	@printf "\n"
	aws s3 sync ./cloudformation-stack s3://${AWS_BUCKET} --exclude "*" --include "*.yaml"
	@printf "\n"

	@printf "Creating the Service Stack...\n"
	@printf "\n"
	aws cloudformation update-stack --stack-name ${JENKINS_SERVICE} --template-url https://s3.amazonaws.com/${AWS_BUCKET}/master.yaml --capabilities "CAPABILITY_NAMED_IAM" --region ${AWS_REGION} --parameters ParameterKey=ECSClusterInstanceType,ParameterValue=${JENKINS_ECS_CLUSTER_INSTANCE_TYPE} ParameterKey=JenkinsImageTag,ParameterValue=${JENKINS_IMAGE} ParameterKey=JenkinsRepository,ParameterValue=${JENKINS_REPO} ParameterKey=BucketName,ParameterValue=${AWS_BUCKET}

deploy: .
	# COMBINE THE PREVIOUS COMMANDS TO DEPLOY CHANGES IN THE IMAGE

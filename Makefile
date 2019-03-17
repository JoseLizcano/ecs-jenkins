all:
    AWS_REGION=us-east-2
    AWS_ACCOUNT_ID=113464717220
    AWS_BUCKET=my-jenkins-infra-jenkinsbucket-17uttznph3na6

    JENKINS_REPO=jenkins_repository
    JENKINS_IMAGE=latest
    JENKINS_BASE=my-jenkins-base
    JENKINS_SERVICE=my-jenkins-service
    JENKINS_ECS_CLUSTER_INSTANCE_TYPE=t2.micro

base: .
	aws cloudformation create-stack --stack-name ${JENKINS_BASE} --template-body file://./base-resources/template.yaml --capabilities "CAPABILITY_NAMED_IAM" --region ${AWS_REGION}

image: .
	docker build -t my_jenkins .
	docker tag my_jenkins ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${JENKINS_REPO}
	eval $(aws ecr get-login --no-include-email --registry-ids ${AWS_ACCOUNT_ID} --region ${AWS_REGION})
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${JENKINS_REPO}

create-stack: .
	aws s3 sync ./cloudformation-stack s3://${AWS_BUCKET} --exclude "*" --include "*.yaml"
	printf "\n"
	aws cloudformation create-stack --stack-name ${JENKINS_SERVICE} --template-url https://s3.amazonaws.com/${AWS_BUCKET}/master.yaml --capabilities "CAPABILITY_NAMED_IAM" --region ${AWS_REGION} --parameters ParameterKey=ECSClusterInstanceType,ParameterValue=${JENKINS_ECS_CLUSTER_INSTANCE_TYPE} ParameterKey=JenkinsImageTag,ParameterValue=${JENKINS_IMAGE} ParameterKey=JenkinsRepository,ParameterValue=${JENKINS_REPO} ParameterKey=BucketName,ParameterValue=${AWS_BUCKET}

update-stack: .
	aws s3 sync ./cloudformation-stack s3://${AWS_BUCKET} --exclude "*" --include "*.yaml"
	printf "\n"
	aws cloudformation update-stack --stack-name ${JENKINS_SERVICE} --template-url https://s3.amazonaws.com/${AWS_BUCKET}/master.yaml --capabilities "CAPABILITY_NAMED_IAM" --region ${AWS_REGION} --parameters ParameterKey=ECSClusterInstanceType,ParameterValue=${JENKINS_ECS_CLUSTER_INSTANCE_TYPE} ParameterKey=JenkinsImageTag,ParameterValue=${JENKINS_IMAGE} ParameterKey=JenkinsRepository,ParameterValue=${JENKINS_REPO} ParameterKey=BucketName,ParameterValue=${AWS_BUCKET}

deploy: .
	# COMBINE THE PREVIOUS COMMANDS TO DEPLOY CHANGES IN THE IMAGE

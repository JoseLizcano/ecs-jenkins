# TODO:
* Create VPC (Ver aquivo de VPC no Bitbucket)
* Create PublicSubnets, PrivateSubnets
* Create KeyPair
* Create makefile
* Disable public access on the load balancer
* See if Docker Volume is really persistent
* Mudar mappings
* Create Jenkins DNS
* Tentar nomear Bucket

`
aws cloudformation create-stack --stack-name my-infra 
--template-body file://./base-resources/template.yaml 
--capabilities "CAPABILITY_NAMED_IAM" 
--region <região da aws>
`


Ver se o dir ao lado do sync funciona ou se era pra deixar o ponto

`aws s3 sync ./cloudformation-stack s3://<bucket_name> --exclude "*" --include "*.yaml"` 

`aws cloudformation create-stack --stack-name my-jenkins-service 
--template-url https://s3.amazonaws.com/<bucket_name>/master.yaml 
--capabilities "CAPABILITY_NAMED_IAM" --region us-east-1 --parameters 
file://./cloudformation-stack/parameters.json`

https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ecs-taskdefinition-dockervolumeconfiguration.html
https://docs.aws.amazon.com/pt_br/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-service.html
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-volumes.html

Testar volume e ver é preciso fazer dockup
https://www.brianchristner.io/docker-backup-dockup/

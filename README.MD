# TODO:
* Change master.yaml, create parameters.json and cli commands
* Create KeyPair
* Create VPC (Ver aquivo de VPC no Bitbucket)
* Create PublicSubnets, PrivateSubnets
* Create makefile
* Disable public access on the load balancer
* See if Docker Volume is really persistent
* Mudar mappings
* Create Jenkins DNS

`
aws cloudformation create-stack --stack-name my-infra 
--template-body file://./base-resources/template.yaml 
--capabilities "CAPABILITY_NAMED_IAM" 
--region <região da aws>
`

https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ecs-taskdefinition-dockervolumeconfiguration.html
https://docs.aws.amazon.com/pt_br/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-service.html
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-volumes.html

Testar volume e ver é preciso fazer dockup
https://www.brianchristner.io/docker-backup-dockup/

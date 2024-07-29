module "bastion" {
    source = "../../modules/bastion"

    key_name = "stg-ehr-eksBastion-keypair"
    bastion_name = "stg-ehr-eksBastion-pub01a"

    iam_role_name = "stg-ehr-eksBastion-iam"
    iam_instance_profile_name = "stg-ehr-eksBastion-profile"
    
    vpc_name = "stg-ehr-vpc"
    subnet_name = "stg-ehr-subnet-pub01a"

    cluster-name = "stg-ehr-eks"
}
module "stage-eks" {
    source = "../../modules/eks"
    cluster-name = "stg-ehr-eks"
    vpc_name = "stg-ehr-vpc"
}
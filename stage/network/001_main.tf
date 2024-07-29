module "webserver_cluster" {
  source = "../../modules/network"

  vpc_name = "stg-ehr-vpc"
  public_subnet_a_name = "stg-ehr-subnet-pub01a"
  public_subnet_c_name = "stg-ehr-subnet-pub01c"
  private_subnet_01a_name = "stg-ehr-subnet-pri01a"
  private_subnet_01c_name = "stg-ehr-subnet-pri01c"
  private_subnet_02a_name = "stg-ehr-subnet-pri02a"
  private_subnet_02c_name = "stg-ehr-subnet-pri02c"
  internet_gateway_name = "stg-ehr-igw"

  nat_gateway_a_name = "stg-ehr-ngw-pub01a"
  nat_gateway_c_name = "stg-ehr-ngw-pub02a"

  public_rtb_a_name = "stg-ehr-rtb-pub01a"
  public_rtb_c_name = "stg-ehr-rtb-pub01c"

  private_rtb_01a_name = "stg-ehr-rtb-pri01a"
  private_rtb_01c_name = "stg-ehr-rtb-pri01c"
  private_rtb_02a_name = "stg-ehr-rtb-pri02a"
  private_rtb_02c_name = "stg-ehr-rtb-pri02c"

  cluster-name = "stg-ehr-eks"
}
```bash
# terraform-ec2-infra
terraform apply -var="name=aasyrafbb" -var="vpc_id=vpc-067f3ab097282bc4d" -var="subnet_id=subnet-0021081c508245985"

terraform apply -var-file="dev.tfvars"

terraform output
terraform output -raw public_ip
terraform output -raw public_dns
terraform output -raw public.ids
terraform output -raw private.ids
```
//curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq

//curl on the above URL will give the details about the instance 

/*data "http" "instance_metadata" {
  url = "http://169.254.169.254/metadata/instance?api-version=2022-03-01"
  headers = {
    "Metadata" = "true"
  }
}

output "instance_metadata" {
  value = jsondecode(data.http.instance_metadata.body)["compute"]
*/

data "http" "instance_metadata" {
  url = "http://169.254.169.254/metadata/instance?api-version=2021-09-01"
  depends_on = [azurerm_virtual_machine.vm1]
}

/*output "compute" {
  value = jsondecode(data.http.instance_metadata.body)["compute"]
}

output "vm_id" {
  value = jsondecode(data.http.instance_metadata.body)["compute"]["vmId"]
}
*/


 locals {
   resource_group_name = "kpmgrg"
   location = "West Europe"
   virtual_network = {
    name= "kpmgnw"
    address_space= "10.0.0.0/16"
}
}
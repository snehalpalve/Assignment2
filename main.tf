resource "azurerm_resource_group" "RG1" {
  name     = "RG1"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = local.location
  resource_group_name = "RG1"
}

resource "azurerm_subnet" "subnetA" {
  name                 = "subnetA"
  resource_group_name  = "RG1"
  virtual_network_name = "vnet1"
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "interface" {
  name                = "interface"
  location            = local.location
  resource_group_name = "RG1"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "vm1"
  resource_group_name = "RG1"
  location            = local.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "admin@1234!"
  network_interface_ids = [
    azurerm_network_interface.interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
    depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_network_interface.interface
  ]

 output "compute" {
  value = jsondecode(data.http.instance_metadata.body)["compute"]
}

 output "vm_id" {
  value = jsondecode(data.http.instance_metadata.body)["compute"]["vmId"]
}
}
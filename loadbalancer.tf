resource "azurerm_public_ip" "loadip" {
  name                = "loadip"
  location            = local.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "webloadbalancer" {
  name                = "webloadbalancer"
  location            = local.location
  resource_group_name = local.resource_group_name
  sku = "Standard"
  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.loadip.id
  }
  depends_on = [
    azurerm_public_ip.loadip
  ]
}
resource "azurerm_lb_backend_address_pool" "poolA" {
  loadbalancer_id = azurerm_lb.webloadbalancer.id
  name            = "PoolA"
  depends_on = [
    azurerm_lb.webloadbalancer
  ]
}

//assign VM's to backend pool
resource "azurerm_lb_backend_address_pool_address" "appvmaddress" {
  count=var.number_of_machines  
  name                    = "webvm${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.poolA.id
  virtual_network_id      = azurerm_virtual_network.webnetwork.id
  ip_address              = azurerm_network_interface.webinterface[count.index].private_ip_address  //private IP add of each interface to backend pool
  depends_on = [
    azurerm_lb_backend_address_pool.poolA,
    azurerm_network_interface.webinterface
  ]
}
//health probe for VM 
resource "azurerm_lb_probe" "probeA" {
  loadbalancer_id = azurerm_lb.webloadbalancer.id
  name            = "probeA"
  port            = 80
  protocol = "Tcp"
  depends_on = [
    azurerm_lb.webloadbalancer
  ]
}
resource "azurerm_lb_rule" "RuleA" {
  loadbalancer_id                = azurerm_lb.webloadbalancer.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80                                 //allowing for https traffic
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend-ip"
  probe_id = azurerm_lb_probe.probeA.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.poolA.id]
  depends_on = [
    azurerm_lb.webloadbalancer
  ]
}

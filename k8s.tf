resource "ionoscloud_datacenter" "dc_02" {
  name                = var.dc_name
  location            = var.dc_location
  description         = var.dc_description
  sec_auth_protection = false
}

resource "ionoscloud_lan" "lan_01" {
  datacenter_id = ionoscloud_datacenter.dc_02.id
  public        = false
  name          = var.lan_name
}

resource "ionoscloud_lan" "lan_02" {
  datacenter_id = ionoscloud_datacenter.dc_02.id
  public        = true
  name          = var.lan_02_name
}

resource "ionoscloud_ipblock" "ipblock_01" {
  location = var.dc_location
  size     = var.ipblock_size
  name     = var.ipblock_name
}

resource "ionoscloud_networkloadbalancer" "nlb_01" {
  datacenter_id  = ionoscloud_datacenter.dc_02.id
  name           = "nlb_01"
  listener_lan   = ionoscloud_lan.lan_02.id
  target_lan     = ionoscloud_lan.lan_01.id
  ips            = ["212.227.51.19"]
  lb_private_ips = ["10.100.0.2/24"]
}
/*
resource "ionoscloud_networkloadbalancer_forwardingrule" "fwd_01" {
  datacenter_id          = ionoscloud_datacenter.dc_02.id
  networkloadbalancer_id = ionoscloud_networkloadbalancer.nlb_01.id
  name                   = "fw-prometheus"
  algorithm              = "SOURCE_IP"
  protocol               = "TCP"
  listener_ip            = "212.227.51.19"
  listener_port          = "8080"
  targets {
    ip     = ""
    port   = "9090"
    weight = "123"
    health_check {
      check          = true
      check_interval = 1000
    }
  }
}
*/

resource "ionoscloud_k8s_cluster" "k8s_cluster_01" {
  name        = var.k8s_name
  k8s_version = var.k8s_ver
  public      = true
  maintenance_window {
    day_of_the_week = "Sunday"
    time            = "09:00:00Z"
  }
}

data "ionoscloud_k8s_cluster" "k8s_cluster_01" {
  name = "k8s_cluster_01"
}

resource "ionoscloud_k8s_node_pool" "k8s_node_pool_01" {
  datacenter_id  = ionoscloud_datacenter.dc_02.id
  k8s_cluster_id = ionoscloud_k8s_cluster.k8s_cluster_01.id
  name           = var.nodepool_name
  k8s_version    = ionoscloud_k8s_cluster.k8s_cluster_01.k8s_version
  maintenance_window {
    day_of_the_week = "Sunday"
    time            = "09:00:00Z"
  }
  auto_scaling {
    min_node_count = 1
    max_node_count = 1
  }
  cpu_family        = "INTEL_SKYLAKE"
  availability_zone = "AUTO"
  storage_type      = "SSD"
  node_count        = 1
  cores_count       = 2
  ram_size          = 2048
  storage_size      = 40
  public_ips        = [ionoscloud_ipblock.ipblock_01.ips[0], ionoscloud_ipblock.ipblock_01.ips[1]]
  /*
  lans {
    id   = ionoscloud_lan.lan_01.id
    dhcp = true
    routes {
      network    = "10.100.0.0/24"
      gateway_ip = "10.100.0.1"
    }
  }
  labels = {
    lab1 = "value1"
    lab2 = "value2"
  }
  annotations = {
    ann1 = "value1"
    ann2 = "value2"
  }
  */
}


provider "kubernetes" {
  host  = data.ionoscloud_k8s_cluster.k8s_cluster_01.config[0].clusters[0].cluster.server
  token = data.ionoscloud_k8s_cluster.k8s_cluster_01.config[0].users[0].user.token
  #config_path = local_file.kubeconfig.filename
  cluster_ca_certificate = data.ionoscloud_k8s_cluster.k8s_cluster_01.ca_crt
}

resource "local_file" "kubeconfig" {
  sensitive_content = yamlencode(jsondecode(data.ionoscloud_k8s_cluster.k8s_cluster_01.kube_config))
  filename          = "kubeconfig.yaml"
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "terraform-example"
    labels = {
      test = "MyExampleApp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "MyExampleApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "example"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

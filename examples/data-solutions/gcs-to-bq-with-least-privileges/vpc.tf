# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###############################################################################
#                                   Networking                                #
###############################################################################

module "vpc" {
  source     = "../../../modules/net-vpc"
  project_id = module.project-service.project_id
  name       = var.vpc_name
  subnets = [
    {
      ip_cidr_range      = var.vpc_ip_cidr_range
      name               = var.vpc_subnet_name
      region             = var.region
      secondary_ip_range = {}
    }
  ]
}

module "vpc-firewall" {
  source       = "../../../modules/net-vpc-firewall"
  project_id   = module.project-service.project_id
  network      = module.vpc.name
  admin_ranges = [var.vpc_ip_cidr_range]
}

module "nat" {
  source         = "../../../modules/net-cloudnat"
  project_id     = module.project-service.project_id
  region         = var.region
  name           = "default"
  router_network = module.vpc.name
}

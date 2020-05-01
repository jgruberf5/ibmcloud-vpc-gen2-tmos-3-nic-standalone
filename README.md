# F5 BIG-IP Virtual Instance for Virtual Private Cloud using Custom Image

Use this template to create F5 BIG-IP virtual instances using a custom image from your IBM Cloud account in IBM Cloud [VPC Gen2](https://cloud.ibm.com/vpc-ext/overview) by using Terraform or IBM Cloud Schematics.  Schematics uses Terraform as the infrastructure-as-code engine.  With this template, you can create and manage infrastructure as a single unit. For more information about how to use this template, see the IBM Cloud [Schematics documentation](https://cloud.ibm.com/docs/schematics).

_The F5 BIG-IP virtual instance supports the following at this time:_
- BYOL licensing.
- 3-NIC, standalone deployments.

## Support

#F5 BIG-IP Virtual Edition - 
You can open a support case in the F5 WebSupport Portal at https://websupport.f5.com/, review additional F5 technical support documentation at https://support.f5.com/csp/article/K25327565 or contact F5 support directly (24x7x365):
- North America: 1-888-882-7535
- Outside North America: +800 11 ASK 4 F5 (800 1127 5435)

F5 support centers are strategically located for partners and customers in APAC, Japan, EMEA and North America. Regionally located support centers enable F5 to provide support in a number of languages through native-speaking engineers who are available when you are. An annual support contract may be purchased separately from F5 Technical Support Services at https://support.f5.com.

#IBM Cloud IaaS Support
You're provided free technical support through the IBM Cloud™ community and Stack Overflow, which you can access from the Support Center. The level of support that you select determines the severity that you can assign to support cases and your level of access to the tools available in the Support Center. Choose a Basic, Advanced, or Premium support plan to customize your IBM Cloud™ support experience for your business needs. 

Learn more; https://www.ibm.com/cloud/support

## Prerequisites

- Must have access to [Gen 2 VPC](https://cloud.ibm.com/vpc-ext/network/vpcs).
- The given VPC must have at least 3 subnets to deploy the BIG-IP.  The first subnet is reserved for management, the second for interal-facing traffic and the third for external facing traffic.  BIG-IP self-IPs will automatically be assigned to each subnet during initial boot.
- The BIG-IP custom image you wish to deploy is present in your list of images. run 'ibmcloud is images' to ensure your image is there. 

## Costs

When you apply template, the infrastructure resources that you create incur charges as follows. To clean up the resources, you can [delete your Schematics workspace or your instance](https://cloud.ibm.com/docs/schematics?topic=schematics-manage-lifecycle#destroy-resources). Removing the workspace or the instance cannot be undone. Make sure that you back up any data that you must keep before you start the deletion process.


* _VPC_: VPC charges are incurred for the infrastructure resources within the VPC, as well as network traffic for internet data transfer. For more information, see [Pricing for VPC](https://cloud.ibm.com/docs/vpc-on-classic?topic=vpc-on-classic-pricing-for-vpc).
* _VPC Custom Image_: The template will copy over a custom F5 image - this can be a one time operation.  F5 virtual instances can be created from the custom image.  VPC charges per custom image.
* _F5 BIG-IP Instances_: The price for your virtual server instances depends on the flavor of the instances, how many you provision, and how long the instances are run. For more information, see [Pricing for Virtual Servers for VPC](https://cloud.ibm.com/docs/infrastructure/vpc-on-classic?topic=vpc-on-classic-pricing-for-vpc#pricing-for-virtual-servers-for-vpc).

## Dependencies

Before you can apply the template in IBM Cloud, complete the following steps.


1.  Ensure that you have the following permissions in IBM Cloud Identity and Access Management:
    * `Manager` service access role for IBM Cloud Schematics
    * `Operator` platform role for VPC Infrastructure
2.  Ensure the following resources exist in your VPC Gen 2 environment
    - VPC
    - SSH Key
    - VPC has 3 subnets, management, internal and external.
    - The custom image you wish to deploy is present in your account.

## Configuring your deployment values

When you select the [`F5-1arm-offering`template](https://cloud.ibm.com/catalog/content/F5-1arm-offering) from the IBM Cloud catalog, you can set up your deployment variables from the `Create` page. Once the template is applied, IBM Cloud Schematics provisions the resources based on the values that were specified for the deployment variables.

### Required values
Fill in the following values, based on the steps that you completed before you began.

| Key | Default | Definition |
| --- | ------- | ---------- |
| `region` | null | The VPC Zone that you want your VPC virtual servers to be provisioned. To list available zones, run `ibmcloud is regions` |
| `ssh_key_name` | null | The name of your public SSH key to be used to login to the BIG-IP instance. Follow [Public SSH Key Doc](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-ssh-keys) for creating and managing ssh keys. |
| `instance_profile` | cx2-2x4 | The profile of compute CPU and memory resources to be used when provisioning the BIG-IP instance. To list available profiles, run `ibmcloud is instance-profiles`. |
| `tmos_image_name` | null | The name of the BIG-IP custom image you wish to deploy. |
| `instance_name` | f5-ve-01 | The hostname of the BIG-IP instance to be provisioned.  Note that the system will add ".local" to this name. |
| `tmos_license_basekey` | null | The registration key to be used to license the BIG-IP. |
| `tmos_admin_password` | null | The password to be used for the admin account on the BIG-IP GUI.  If left blank, this will generate a random, 32 byte password. |
| `management_subnet_id` | null |The ID of the subnet where the BIG-IP management interface will be deployed. Click on the subnet details in the VPC Subnet Listing to determine this value.  Note that a floating IP will automatically be created for this interface. | 
| `internal_subnet_id` | null | The ID of the subnet where the BIG-IP internal interface will be deployed. Click on the subnet details in the VPC Subnet Listing to determine this value | 
| `external_subnet_id` | null | The ID of the subnet where the BIG-IP external interface will be deployed. Click on the subnet details in the VPC Subnet Listing to determine this value | 

### Outputs
After you apply the template your VPC resources are successfully provisioned in IBM Cloud, you can review information such as the virtual server IP addresses and VPC identifiers in the Schematics log files, in the `Terraform SHOW and APPLY` section.

| Variable Name | Description | Sample Value |
| ------------- | ----------- | ------------ |
| `resource_name` | Name of the F5 BIG-IP instance | N/A |
| `resource_status` | Status of the F5 BIG-IP instance | `Running` or `Failed` |
| `VPC` | The VPC ID | `r134-7a9df886-xxxx-yyyy-zzzz-67c6dd202337` |
| `f5_admin_portal` | Web url to interact with F5-BIGIP admin portal - `https://<Floating IP>:8443` | `https://192.168.1.1:8443` |

## Notes

If there is a failure during F5 BIG-IP instance creation, the created resources must be destroyed before attempting to instantiate again. To destroy resources go to `Schematics -> Workspaces -> [Your Workspace] -> Actions -> Delete` to delete  all associated resources. <br/>
1. The BYOI image download may take a while. Timeout has been set 30 Minutes.
2. Do not modify or delete subnets and floating/public IPs used by the F5-BIGIP instance.

# Post F5-BIGIP Instance Spin-up

1. From the VPC list, confirm the F5-VSI is powered ON with green button
2. Assign a Floating IP to the F5-VSI. Refer the steps below to associate floating IP
    - Go to `VPC Infrastructure Gen 2` from IBM Cloud
    - Click `Floating IPs` from the left pane
    - Click `Reserve floating IP` -> Click `Reserve IP`
    - There will be a (new) Floating IP address with status `Unassociated`
    - Click Three Dot Button corresponding to the Unassociated IP address -> Click `Associate`
    - Select F5 instance from `Instance to be associated` column.
    - After clicking `Associate`, you can see the IP address assigned to your F5 Instance.
3. In the Security group,  here are the steps to open the port 8443
    - Go to `VPC Infrastructure Gen 2` from IBM Cloud
    - Click `Security groups` from the left pane
    - Click the security group which is corresponding to your VPC
    - Click `New Rule` in "Inbound Rules" column.
    - Select `Protocol` as "TCP"
    - Select `Port Range` under Port
    - Give `8443` port number in `Port min` and `Port max`
    - Select `Source type` as `Any`
    - Click `Save`, and a new rule will be added to your security group
4. From the browser, open `https://<Floating IP>:8443`, login using user and password 
5. In First login, it will ask to reset the password.
6. Once the password got reset. You will be able to login to F5 instance admin portal.


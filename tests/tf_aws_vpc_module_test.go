package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestCompleteVpv(t *testing.T) {
	// t.parallel()

	awsRegion := "eu-west-1"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/complete",
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform outputList` to get the value of an output variable
	// We use ouputList instead to Output because the ouput is contains 3 ids and we need to iterate it.

	publicSubnetIds := terraform.OutputList(t, terraformOptions, "public_subnet_ids")
	privateSubnetIds := terraform.OutputList(t, terraformOptions, "private_subnet_ids")
	databaseSubnetIds := terraform.OutputList(t, terraformOptions, "database_subnet_ids")

	vpcId := terraform.Output(t, terraformOptions, "vpc_id")

	subnets := aws.GetSubnetsForVpc(t, vpcId, awsRegion)

	require.Equal(t, 9, len(subnets))

	// Verify if the network that is supposed to be public is really public
	for _, element := range publicSubnetIds {
		assert.True(t, aws.IsPublicSubnet(t, element, awsRegion))
	}
	// // Verify if the network that is supposed to be private is really private
	for _, element := range privateSubnetIds {
		assert.False(t, aws.IsPublicSubnet(t, element, awsRegion))
	}
	// // Verify if the network that is supposed to be private is really private
	for _, element := range databaseSubnetIds {
		assert.False(t, aws.IsPublicSubnet(t, element, awsRegion))
	}
}

# load data from Terraform output
content = inspec.profile.file("outputs.json.local")
params = JSON.parse(content)
# Get outputs
storage_account_id = params['storage_account_id']['value']
storage_account_name = params['storage_account_name']['value']

title "CNA Inspec Test"

control 'Cloud Region' do
  impact 1.0
  title "Check Input from example deployment."
  desc "Check necessary Input parameter CLOUD_REGION"
  describe input('CLOUD_REGION') do    # This line reads the value of the input
    it { should be_in ['germanywestcentral', 'westeurope', 'eastus'] }
  end
end

control 'Azure Storage Account Outputs' do
  impact 1.0
  title "Check Azure Storage Account deployment"
  desc "Check outputs from Example & deployment of a Storage Account"
  describe azure_storage_account(resource_id: storage_account_id) do
    it { should exist }
    its ('name') { should eq storage_account_name }
    its ('properties.accessTier') { should eq 'Hot'}
    its ('properties.allowBlobPublicAccess') { should eq false }
  end
end

module OrganizationsHelper
  def org_url(organization)
    org_param = Officer.organization_to_param(organization)
    organization_url(org_param) if org_param != nil
  end
end

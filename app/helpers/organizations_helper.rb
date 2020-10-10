module OrganizationsHelper
  def org_name(organization_officers)
    organization_officers[0].organization
  end
end

module OrganizationsHelper
  def org_name(organization_officers)
    format_unknown if organization_officers.length == 0
    organization_officers[0].organization
  end
end

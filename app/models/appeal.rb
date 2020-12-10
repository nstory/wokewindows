class Appeal < ApplicationRecord
  serialize :decision_urls, Array
  scoped_search on: [:decisions_text, :custodian]

  def appeal_status_detail_url
    if appeal_no
      "https://www.sec.state.ma.us/AppealsWeb/AppealStatusDetail.aspx?AppealNo=#{URI.encode_www_form_component(appeal_no)}"
    end
  end

  def to_param
    case_no
  end
end

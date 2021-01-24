class Appeal < ApplicationRecord
  serialize :decision_urls, Array
  scoped_search on: :decisions_text
  scoped_search on: :custodian
  scoped_search on: :resp_prov_date, only_explicit: true

  def appeal_status_detail_url
    if appeal_no
      "https://www.sec.state.ma.us/AppealsWeb/AppealStatusDetail.aspx?AppealNo=#{URI.encode_www_form_component(appeal_no)}"
    end
  end

  def spr
    "SPR#{case_no[2 .. 3]}/#{case_no[-4 .. -1]}"
  end

  def to_param
    case_no
  end
end

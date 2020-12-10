FactoryBot.define do
  factory :appeal do
    case_no { "20200042" }

    factory :norris_appeal do
      case_type { "Appeal" }
      case_subtype { "Reconsideration" }
      status { "Closed" }
      case_no { "20192106" }
      appeal_no { "xyzzy" }
      requester { "Norris, Chuck" }
      custodian { "Executive Office of Public Safety and Security - Massachusetts Parole Board" }
      req_rec_date { "2019-08-19" }
      resp_prov_date { "2019-08-30" }
      fees { "0.00" }
      petitions { "No" }
      comply { "6 business days" }
      date_opened { "2019-10-15" }
      date_closed { "2019-10-29" }
      reconsider_open_date { "2019-12-13" }
      reconsider_close_date { "2020-01-07" }
      in_cam_open_date { "2019-11-06" }
      in_cam_close_date { "2019-11-29" }
      request_to_court { "No" }
      decisions_text { "lol omg rofl lmao" }
    end
  end
end

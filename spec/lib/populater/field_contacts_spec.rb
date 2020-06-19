describe Populater::FieldContacts do
  let(:field_contact_name) do
    FieldContactName.new({frisked_searched: true})
  end

  let!(:field_contact) do
    FieldContact.create({
      fc_num: "FC1",
      field_contact_names: [field_contact_name]
    })
  end

  it "populates" do
    Populater::FieldContacts.populate
    expect(field_contact.reload.frisked_searched).to eql(true)
  end

  describe "frisked_searched already set to true" do
    let(:field_contact_name) do
      FieldContactName.new({frisked_searched: false})
    end

    before do
      field_contact.frisked_searched = true
      field_contact.save
    end

    it "keeps it set" do
      Populater::FieldContacts.populate
      expect(field_contact.reload.frisked_searched).to eql(true)
    end
  end

  describe "no-one searched" do
    let(:field_contact_name) do
      FieldContactName.new({frisked_searched: false})
    end

    it "sets frisked_searched false" do
      Populater::FieldContacts.populate
      expect(field_contact.reload.frisked_searched).to eql(false)
    end
  end
end

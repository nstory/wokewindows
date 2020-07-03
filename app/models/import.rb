# records what files have been succesfully imported
class Import < ApplicationRecord
  def self.import_once(name)
    import = Import.find_by(name: name)
    if !import
      yield
      Import.create(name: name)
    end
  end
end

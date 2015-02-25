# I'm currently using Fabrication gem to generate objects but if this changes now I can make the change in one place
# use generator instead of Fabricate
# user attributes_for instead of Fabricate.attributes_for

def object_generator(*args)
  Fabricate(*args)
end

def generate_attributes_for(*args)
  Fabricate.attributes_for(*args)
end

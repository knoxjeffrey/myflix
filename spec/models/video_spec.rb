require 'spec_helper'
    
describe Video do
  
  it "saves itself" do
    video = Video.new(title: "Monk", description: "Series about a detective")

    video.save
    expect(Video.first.title).to eq("Monk")
    expect(Video.first.description).to eq("Series about a detective")
  end

end

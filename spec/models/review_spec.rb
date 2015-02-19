require 'spec_helper'

describe Review do
  it { should belong_to :video }
  it { should belong_to :user }
  
  it { should validate_presence_of :rating }
  it { should validate_presence_of :body }
  
  it { should validate_uniqueness_of(:user_id).scoped_to(:video_id) }
end
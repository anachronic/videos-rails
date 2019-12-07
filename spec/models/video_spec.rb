require 'rails_helper'

RSpec.describe Video, type: :model do
  let(:image) {
    image = fixture_file_upload(
      Rails.root.join('spec', 'factories', 'assets', 'pear.jpg'),
      'image/jpeg'
    )
  }

  describe "Creating a video" do
    it 'Validates name presence' do
      expect{ Video.create! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'Adds a new attachment when creating a video with attachment' do
      expect {
        Video.create!(name: 'A video with attachment', file: image)
      }.to change(ActiveStorage::Attachment, :count).by(1)
    end
  end

  describe "Editing an existing video" do
    it 'Edits correctly when passing only name' do
      valid_video = Video.create!(name: 'Some name')
      expect {
        valid_video.update!(name: 'A new name')
      }.not_to raise_error
    end

    it 'Fails to edit on empty name' do
      valid_video = Video.create!(name: 'A good video')
      expect {
        valid_video.update!(name: '')
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'Deleting a video' do
    it 'Does not fail on deletion' do
      valid_video = Video.create!(name: 'delete me!')
      expect {
        valid_video.destroy!
      }.to_not raise_error
    end

    it 'Decrements active storage items by 1 on successful deletion' do
      video = Video.create!(name: 'Video with attachment', file: image)

      expect { video.destroy! }.to change(ActiveStorage::Attachment, :count).by(-1)
    end
  end
end

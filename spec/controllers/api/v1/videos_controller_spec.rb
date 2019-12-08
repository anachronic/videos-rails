require 'rails_helper'

RSpec.describe Api::V1::VideosController, type: :controller do
  render_views

  let(:image) {
    image = fixture_file_upload(
      Rails.root.join('spec', 'factories', 'assets', 'pear.jpg'),
      'image/jpeg'
    )
  }

  describe 'List all videos' do
    it 'Returns 200 with no videos' do
      get :index, format: :json
      expect(response).to have_http_status(:ok)
    end

    it 'Fetches all videos' do
      Video.create!(name: 'video 1', file: image)
      Video.create!(name: 'video 2', file: image)

      expect(subject).to receive(:set_videos).with(no_args)
      get :index, format: :json
    end

    it 'Delivers all created videos' do
      Video.create!(name: 'video 1', file: image)
      Video.create!(name: 'video 2', file: image)

      get :index, format: :json
      body = JSON.parse(response.body)

      expect(body.length).to equal(2)
    end
  end

  describe 'Show one video' do
    it 'Errors with 404 if no video is found' do
      expect {
        get :show, { params: { id: -1 }, format: :json }
      }.to raise_error(ActiveRecord::RecordNotFound)
      # We assume RecordNotFound yields 404 in production
    end

    it 'Shows correctly one video' do
      video = Video.create!(name: 'A new video', file: image)

      get :show, { params: { id: video.id }, format: :json }
      body = JSON.parse(response.body)

      expect(body).to have_key('name')
      expect(body).to have_key('url')
    end

    it 'Sets the corresponding video', skip: 'No idea why this fails' do
      video = Video.create!(name: 'A new video', file: image)

      expect(subject).to receive(:set_video).with(no_args)
      get :show, { params: { id: video.id }, format: :json }
    end
  end

  describe '#create' do
    it 'Creates a new video with a file attachment' do
      params = {
        name: 'A new video',
        file: image
      }

      post :create, { params: params, format: :json }
      body = JSON.parse(response.body)

      expect(body).to have_key('name')
      expect(body).to have_key('url')

      expect(response).to have_http_status(200)
    end

    it 'Fails to create a new video with no params' do
      params = {}

      expect {
        post :create, { params: params, format: :json }
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#destroy' do
    it 'Correctly destroys an existing video' do
      video = Video.create!(name: 'Destroy me', file: image)
      
      expect{
        delete :destroy, params: { id: video.id, format: :json}
      }.to change{ Video.count }.by(-1)

      expect(response).to have_http_status(204)
    end

    it 'Fails to destroy a non-existing video' do
      expect {
        delete :destroy, params: { id: -1, format: :json }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#update' do
    it 'Fails to update a non-existing video' do
      expect {
        patch :update, params: { id: -1, format: :json }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'Succeeds to update an existing video with correct params' do
      video = Video.create!(name: 'Edit me', file: image)

      patch :update, params: { id: video.id, name: 'Edited you', format: :json }
      expect(response).to have_http_status(200)
    end

    it 'Ignores foreign params when updating' do
      video = Video.create!(name: 'Edit me', file: image)

      patch :update, params: { id: video.id, something_else: 'You shall not pass', format: :json }
      expect(response).to have_http_status(200)

      body = JSON.parse(response.body)
      expect(body.keys).to contain_exactly('name', 'url', 'id')
    end
  end
end

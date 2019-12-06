json.id video.id
json.name video.name

if video.file.attached?
  json.url rails_blob_url(video.file, only_path: true)
end

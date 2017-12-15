json.extract! site, :id, :site_name, :short_name, :region, :information, :created_at, :updated_at
json.url site_url(site, format: :json)

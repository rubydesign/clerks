# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( ruby_clerks.css ruby_clerks.js  )
Rails.application.config.assets.precompile += %w( ruby_clerks/*.jpg  up-icon.png down-icon.png )
Rails.application.config.assets.precompile += ["missing_thumb.png", "missing.png", "missing_list.png", "missing_product.png"]

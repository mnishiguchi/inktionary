# frozen_string_literal: true

module ApplicationHelper
  def full_title(page_title = "", base_title = Rails.application.class.module_parent_name.titlecase)
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def flash_tag
    messages = []

    flash.each do |type, message|
      next if message.blank?

      level = case type
              when "notice" then "success"
              when "alert"  then "error"
              when "info"   then "info"
              when "warn"   then "warn"
              else
                "info"
              end

      js = %[iziToast.#{level}({ title: '#{level.capitalize}:', message: "#{message}" });]
      messages << javascript_tag(js)
    end

    messages.join("/n").html_safe
  end

  def form_page_content_container_tag
    content_tag(:div, class: "container") do
      content_tag(:div, class: "row") do
        content_tag(:div, class: "col-md-10 offset-md-1 col-lg-8 offset-lg-2") do
          yield
        end
      end
    end
  end

  # Returns the Gravatar for the given user.
  def gravatar_for(email, options = { size: 80 })
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, title: email, class: "gravatar img-thumbnail")
  end
end

# frozen_string_literal: true

# Adds loading="lazy" and decoding="async" to <img> tags inside the content
# area (<main>) of rendered HTML pages. Images that already set loading=
# are left alone, and nothing outside <main> (sidebar, header, logo) is touched.
# :documents fires once for every document, including posts and projects,
# so posts and projects are not registered separately.
module LazyImages
  MAIN = %r{<main\b.*?</main>}m
  IMG = /<img\b(?![^>]*\bloading=)/i

  module_function

  def apply(html)
    html.gsub(MAIN) { |main| main.gsub(IMG, '<img loading="lazy" decoding="async"') }
  end
end

Jekyll::Hooks.register [:documents, :pages], :post_render do |doc|
  next unless doc.output_ext == '.html' && doc.output.is_a?(String)

  doc.output = LazyImages.apply(doc.output)
end

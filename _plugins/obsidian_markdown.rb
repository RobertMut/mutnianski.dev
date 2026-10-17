# frozen_string_literal: true

# Makes Markdown written in Obsidian render the same way under kramdown:
#   - [[#Heading|alias]], [[Note]], [[Note#Heading|alias]] become regular links
#   - consecutive text lines become separate paragraphs
# Runs once after the site is read, so excerpts see the converted content too.
module ObsidianMarkdown
  MARKDOWN_EXT = %w[.md .markdown].freeze
  FENCE = /\A {0,3}(`{3,}|~{3,}|\$\$)/
  WIKILINK = /(?<!!)\[\[([^\]|#]*)(?:#([^\]|]*))?(?:\|([^\]]*))?\]\]/
  CODE_SPAN = /(`+[^`]*`+)/
  # Multi-line blocks: lines following them up to a blank line are left alone.
  CONTAINER_LINE = Regexp.union(
    /\A\s*([-*+]|\d+[.)])\s/,  # list item
    /\A\s*>/,                  # blockquote
    /\|/,                      # table row
    /\A\s*</,                  # HTML
    /\A( {4}|\t)/              # indented code / continuation
  )
  # Single-line blocks: never split around them.
  SINGLE_LINE = Regexp.union(
    /\A\s*#/,                  # heading
    /\A\s*\{[%:]/,             # Liquid tag, kramdown IAL
    /\A\s*\[[^\]]+\]:/,        # link or footnote definition
    /\A\s*\*\[/,               # abbreviation
    /\A\s*[-=*_]{3,}\s*\z/     # rule or setext underline
  )

  module_function

  def convert(content, links)
    out = []
    fence = nil
    in_block = false
    prev = nil

    content.each_line(chomp: true) do |line|
      if fence
        fence = nil if line.lstrip.start_with?(fence)
        out << line
        next
      end

      if (m = FENCE.match(line))
        fence = m[1][0] == '$' ? '$$' : m[1]
        in_block = false
        out << line
        prev = nil
        next
      end

      if line.strip.empty?
        in_block = false
      elsif CONTAINER_LINE.match?(strip_wikilinks(line))
        in_block = true
      elsif !in_block && text_line?(line) && prev && text_line?(prev) && !prev.end_with?('  ', '\\')
        out << ''
      end

      out << replace_wikilinks(line, links)
      prev = line
    end

    out.join("\n") + (content.end_with?("\n") ? "\n" : '')
  end

  def text_line?(line)
    bare = strip_wikilinks(line)
    !line.strip.empty? && !CONTAINER_LINE.match?(bare) && !SINGLE_LINE.match?(bare)
  end

  def strip_wikilinks(line)
    line.gsub(WIKILINK, 'link')
  end

  def replace_wikilinks(line, links)
    line.split(CODE_SPAN).each_with_index.map do |part, i|
      next part if i.odd?

      part.gsub(WIKILINK) do
        note = Regexp.last_match(1).strip
        heading = Regexp.last_match(2)&.strip
        text = Regexp.last_match(3)&.strip
        text = [note, heading].reject { |s| s.nil? || s.empty? }.join(' > ') if text.nil? || text.empty?
        anchor = heading && !heading.empty? ? "##{anchor_id(heading)}" : ''

        if note.empty?
          "[#{text}](#{anchor})"
        elsif (url = links[note.downcase])
          "[#{text}](#{url}#{anchor})"
        else
          text
        end
      end
    end.join
  end

  # Same algorithm as kramdown's auto_ids.
  def anchor_id(heading)
    id = heading.gsub(/\A[^a-zA-Z]+/, '')
    id.tr('^a-zA-Z0-9 -', '').tr(' ', '-').downcase
  end

  def link_map(site, docs)
    docs.each_with_object({}) do |doc, map|
      url = "#{site.baseurl}#{doc.url}"
      keys = [doc.data['title'], doc.data['slug'], File.basename(doc.path, '.*')]
      keys << doc.basename_without_ext.sub(/\A\d{4}-\d{2}-\d{2}-/, '') if doc.respond_to?(:basename_without_ext)
      keys.compact.each { |key| map[key.to_s.downcase] ||= url }
    end
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  docs = (site.documents + site.pages).select do |doc|
    ObsidianMarkdown::MARKDOWN_EXT.include?(File.extname(doc.path).downcase)
  end
  links = ObsidianMarkdown.link_map(site, docs)

  docs.each do |doc|
    doc.content = ObsidianMarkdown.convert(doc.content.to_s, links)
    doc.data['excerpt'] = Jekyll::Excerpt.new(doc) if doc.data['excerpt'].is_a?(Jekyll::Excerpt)
  end
end

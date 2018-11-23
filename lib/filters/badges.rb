# frozen_string_literal: true

# GitLab price / tiers badge
#
# This allows us to add visual Badges to our documentation using standard Markdown
# that will render in any markdown editor.
#
# The available pattern is `**[<BADGE_TYPE> <MODIFIER>]**`
# The following TIERS are supported: CORE, STARTER, PREMIUM, ULTIMATE
# The following MODIFIERS are supported: ONLY
#
# When you have ONLY as MODIFIER, it means, it applies only for on premise instances
# so we are not going to expand "STARTER" to "BRONZE" as well.
class BadgesFilter < Nanoc::Filter
  identifier :badges

  BADGES_HTML_PATTERN = %r{
    <strong>
    \[
    (?<badge_type>CORE|STARTER|PREMIUM|ULTIMATE)(?:\s+(?<only>ONLY))?
    \]
    </strong>
  }x

  BADGES_MARKDOWN_PATTERN = %r{
    (?:^|[^`]) # must be start of the line or anything except backtick
    \*\*\[
    (?<badge_type>CORE|STARTER|PREMIUM|ULTIMATE)(?:\s+(?<only>ONLY))
    ?\]\*\*
    (?:$|[^`]) # must end of line or anything except backtick
  }x

  def run(content, params = {})
    content.gsub(BADGES_HTML_PATTERN) { generate(Regexp.last_match[:badge_type].downcase, !Regexp.last_match[:only].nil?) }
  end

  def run_from_markdown(content)
    content.gsub(BADGES_MARKDOWN_PATTERN) { generate(Regexp.last_match[:badge_type].downcase, !Regexp.last_match[:only].nil?) }
  end

  def generate(badge_type, only)
    if only
      %(<span class="badge-trigger #{badge_type}-only"></span>)
    else
      %(<span class="badge-trigger #{badge_type}"></span>)
    end
  end
end

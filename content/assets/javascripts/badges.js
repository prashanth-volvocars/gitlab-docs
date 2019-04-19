---
version: 2
---

(function() {
  var BADGES_TITLES = {
    core: 'Available in GitLab Core, GitLab.com Free, and higher tiers',
    starter: 'Available in GitLab Starter, GitLab.com Bronze, and higher tiers',
    premium: 'Available in GitLab Premium, GitLab.com Silver, and higher tiers',
    ultimate: 'Available in GitLab Ultimate and GitLab.com Gold',
    'core-only':
      'Available in GitLab Core and higher tiers. Not available in GitLab.com',
    'starter-only':
      'Available in GitLab Starter and higher tiers. Not available in GitLab.com',
    'premium-only':
      'Available in GitLab Premium and higher tiers. Not available in GitLab.com',
    'ultimate-only':
      'Available in GitLab Ultimate. Not available in GitLab.com',
    'bronze-only':
      'Available in GitLab Bronze and higher tiers. Not available in self-hosted instances.',
    'silver-only':
      'Available in GitLab Silver and higher tiers. Not available in self-hosted instances.',
    'gold-only':
      'Available in GitLab Gold. Not available in self-hosted instances.',
  };

  var BADGES_MAPPING = {
    core: ['core', 'free'],
    starter: ['starter', 'bronze'],
    premium: ['premium', 'silver'],
    ultimate: ['ultimate', 'gold'],
    'core-only': ['core'],
    'starter-only': ['starter'],
    'premium-only': ['premium'],
    'ultimate-only': ['ultimate'],
    'bronze-only': ['bronze'],
    'silver-only': ['silver'],
    'gold-only': ['gold'],
  };

  var BADGES_CLASS = {
    core: 'gitlab',
    starter: 'gitlab',
    premium: 'gitlab',
    ultimate: 'gitlab',
    free: 'gitlab-com',
    bronze: 'gitlab-com',
    silver: 'gitlab-com',
    gold: 'gitlab-com',
  };

  function init() {
    var $badges = $('.badge-trigger');

    $badges.each(function() {
      convertBadge($(this));
    });

    $('[data-toggle="tooltip"]').tooltip();
  }

  function convertBadge($badge) {
    var small = isSmall($badge);
    var badgeType = retrieveBadgeType($badge);

    var smallBadgeTag = function(title) {
      return $('<span>', {
        class: 'badge-small',
        html: '<i class="fa fa-question-circle-o" aria-hidden="true"></i>',
        'data-title': title,
      });
    };

    var largeBadgeTag = function(badge, badgeClass) {
      return $('<div>', {
        class: 'badge-display badge-' + badgeClass,
        text: badge,
      });
    };

    var template = function(title, badges) {
      var container = $('<a>', {
        class: 'badges-drop',
        'data-toggle': 'tooltip',
        'data-placement': 'top auto',
        'target': '_blank',
        title: title,
        href: 'https://about.gitlab.com/pricing/'
      });
      container.append($('<span>').append(badges));

      return container;
    };

    var tags = [];

    if (small) {
      tags.push(smallBadgeTag(BADGES_MAPPING[badgeType].join(' | ')));
    } else {
      $.each(BADGES_MAPPING[badgeType], function(i, badge) {
        tags.push(largeBadgeTag(badge, BADGES_CLASS[badge]));
      });
    }

    $badge.append($(template(BADGES_TITLES[badgeType], tags)));
  }

  // Get the badge type from a specific list of expected values in element class
  function retrieveBadgeType($badge) {
    var match = $badge
      .attr('class')
      .match(
        /core-only|core|starter-only|premium-only|ultimate-only|starter|premium|ultimate|bronze-only|silver-only|gold-only/
      );

    if (match) {
      return match.pop();
    }
  }

  // When badge is not in a HTML header, we use the small version
  function isSmall($badge) {
    return !$badge
      .parent()
      .prop('tagName')
      .match(/H1|H2|H3|H4|H5/);
  }

  $(function() {
    init();
  });
})();
